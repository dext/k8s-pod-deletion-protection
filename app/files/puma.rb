threads_count = Integer(ENV['THREADS_COUNT'] || 2)
threads threads_count, threads_count

port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

if ENV['SSL_ENABLED']
  ssl_bind '0.0.0.0', 443, {
    key: File.expand_path('/certs/tls.key'),
    cert: File.expand_path('/certs/tls.crt'),
    verify_mode: 'none',
  }
end
