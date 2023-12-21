require 'json'
require 'logger'
require 'sinatra'
require 'sinatra/json'
require 'net/http'

LOGGER = Logger.new $stdout
LOGGER.level = ENV['LOG_LEVEL'] || 'INFO'

API_HOST = ENV['K8S_API_HOST'] || 'kubernetes.default.svc.cluster.local'.freeze
TOKEN = File.read '/var/run/secrets/kubernetes.io/serviceaccount/token'
CA_CERT = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'.freeze

def node_ready?(node_name)
  http = Net::HTTP.new API_HOST, 443
  http.use_ssl = true
  http.ca_file = CA_CERT
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  request = Net::HTTP::Get.new "/api/v1/nodes/#{node_name}"
  request.add_field 'Authorization', "Bearer #{TOKEN}"
  response = http.request request

  node = JSON.parse response.body

  LOGGER.debug { "Node '#{node_name}' status: #{JSON.pretty_generate node}" }

  node['reason'] != 'NotFound' && node['status']['conditions'].any? { _1['type'] == 'Ready' && _1['status'] == 'True' }
end

def admission_response(request_uid, pod_name, request_allowed)
  {
    'apiVersion': 'admission.k8s.io/v1',
    'kind': 'AdmissionReview',
    'response': {
      'uid': request_uid,
      'allowed': request_allowed,
      'status': {
        'message': "Deletion of pod #{pod_name} #{request_allowed ? 'allowed' : 'denied'}",
        'code': request_allowed ? 200 : 403
      }
    }
  }
end

post '/validate' do
  req = request.body.read

  LOGGER.debug { "Request body: #{req}" }

  payload = JSON.parse(req)['request']

  node_name = payload['oldObject']['spec']['nodeName']
  pod_name = payload['name']
  pod_operation = payload['operation']

  request_allowed = !node_ready?(node_name)

  LOGGER.info "#{pod_operation} of #{pod_name} running on #{node_name} #{request_allowed ? 'allowed' : 'denied'}."

  response = admission_response payload['uid'], pod_name, request_allowed

  LOGGER.debug { "Admission response: #{JSON.pretty_generate response}" }

  json response
end
