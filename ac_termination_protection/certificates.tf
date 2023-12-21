resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem       = tls_private_key.ca.private_key_pem
  is_ca_certificate     = true
  validity_period_hours = 100000

  subject {
    common_name  = "${var.name}.${var.namespace}.svc"
    organization = "system"
  }

  allowed_uses = [
    "cert_signing",
    "server_auth",
  ]
}

resource "tls_private_key" "private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "private" {
  private_key_pem = tls_private_key.private.private_key_pem

  dns_names = [
    var.name,
    "${var.name}.${var.namespace}.svc",
    "${var.name}.${var.namespace}.svc.cluster.local",
  ]
}

resource "tls_locally_signed_cert" "private" {
  cert_request_pem      = tls_cert_request.private.cert_request_pem
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  validity_period_hours = 100000

  allowed_uses = [
    "server_auth",
  ]
}
