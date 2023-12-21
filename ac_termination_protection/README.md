<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.24.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.24.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role.termination_protection](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.termination_protection](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_daemonset.termination_protection](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/daemonset) | resource |
| [kubernetes_secret.termination_protection](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/secret) | resource |
| [kubernetes_service.termination_protection](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/service) | resource |
| [kubernetes_service_account.termination_protection](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/service_account) | resource |
| [kubernetes_validating_webhook_configuration.termination_protection](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/validating_webhook_configuration) | resource |
| [tls_cert_request.private](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.private](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.ca](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/private_key) | resource |
| [tls_private_key.private](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/private_key) | resource |
| [tls_self_signed_cert.ca](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/self_signed_cert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | The docker image to use for the container | <pre>object({<br>    name = string<br>    args = list(string)<br>  })</pre> | <pre>{<br>  "args": [<br>    "-C",<br>    "puma.rb"<br>  ],<br>  "name": "vutoff/k8s-termination-protection:v0.1"<br>}</pre> | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | The environment variables for the container | `map(string)` | <pre>{<br>  "RACK_ENV": "production",<br>  "SSL_ENABLED": "true"<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the resource | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace of the resource | `string` | n/a | yes |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | The node selector for the pod | `map(string)` | <pre>{<br>  "node-role.kubernetes.io/master": true<br>}</pre> | no |
| <a name="input_resources"></a> [resources](#input\_resources) | The resource limits and requests for the container | <pre>map(object({<br>    limits   = map(string)<br>    requests = map(string)<br>  }))</pre> | <pre>{<br>  "limits": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  },<br>  "requests": {<br>    "cpu": "50m",<br>    "memory": "100Mi"<br>  }<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->