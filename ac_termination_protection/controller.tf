resource "kubernetes_service_account" "termination_protection" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "termination_protection" {
  metadata {
    name = var.name
  }

  rule {
    api_groups = ["*"]
    resources  = ["nodes"]
    verbs      = ["get", "watch", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "termination_protection" {
  metadata {
    name = var.name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.termination_protection.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.termination_protection.metadata[0].name
    namespace = kubernetes_service_account.termination_protection.metadata[0].namespace
  }
}

resource "kubernetes_validating_webhook_configuration" "termination_protection" {
  metadata {
    name = var.name
  }

  webhook {
    name                      = "${var.name}.${var.namespace}.svc.cluster.local"
    side_effects              = "None"
    failure_policy            = "Fail"
    timeout_seconds           = 5
    admission_review_versions = ["v1"]

    object_selector {
      match_labels = {
        protected = true
      }
    }

    rule {
      api_groups   = ["*"]
      api_versions = ["*"]
      resources    = ["pods"]
      operations   = ["DELETE"]
      scope        = "*"
    }

    client_config {
      ca_bundle = tls_self_signed_cert.ca.cert_pem
      service {
        name      = kubernetes_service_account.termination_protection.metadata[0].name
        namespace = kubernetes_service_account.termination_protection.metadata[0].namespace
        path      = "/validate"
      }
    }
  }
}

resource "kubernetes_secret" "termination_protection" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  data = {
    "tls.crt" = tls_locally_signed_cert.private.cert_pem
    "tls.key" = tls_private_key.private.private_key_pem
  }
}

resource "kubernetes_daemonset" "termination_protection" {
  metadata {
    name      = var.name
    namespace = var.namespace

    labels = {
      app = var.name
    }
  }

  spec {
    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app       = var.name
          component = "admission-controller"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.termination_protection.metadata[0].name

        node_selector = var.node_selector

        security_context {
          run_as_user = 65534
          fs_group    = 65534
        }

        dns_config {
          option {
            name  = "ndots"
            value = "1"
          }
        }

        container {
          name  = var.name
          image = var.docker_image.name
          args  = var.docker_image.args

          dynamic "env" {
            for_each = var.env_vars

            content {
              name  = env.key
              value = env.value
            }
          }

          volume_mount {
            read_only  = true
            name       = var.name
            mount_path = "/certs"
          }

          resources {
            limits   = var.resources.limits
            requests = var.resources.requests
          }
        }

        volume {
          name = var.name

          secret {
            secret_name = kubernetes_secret.termination_protection.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "termination_protection" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.name
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
    }
  }
}
