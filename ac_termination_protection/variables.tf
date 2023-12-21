variable "name" {
  type        = string
  description = "The name of the resource"
}

variable "namespace" {
  type        = string
  description = "The namespace of the resource"
}

variable "docker_image" {
  description = "The docker image to use for the container"

  type = object({
    name = string
    args = list(string)
  })

  default = {
    name = "vutoff/k8s-termination-protection:v0.1"
    args = [
      "-C",
      "puma.rb"
    ]
  }
}

variable "resources" {
  type = object({
    limits   = map(string)
    requests = map(string)
  })
  default = {
    limits = {
      cpu    = "100m"
      memory = "100Mi"
    }
    requests = {
      cpu    = "50m"
      memory = "100Mi"
    }
  }

  description = "The resource limits and requests for the container"
}

variable "env_vars" {
  type = map(string)

  default = {
    RACK_ENV    = "production"
    SSL_ENABLED = "true"
  }

  description = "The environment variables for the container"
}

variable "node_selector" {
  description = "The node selector for the pod"

  type = map(string)
  default = {
    "node-role.kubernetes.io/master" = "true"
  }
}
