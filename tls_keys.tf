# ED25519 key
resource "tls_private_key" "this" {
  count = var.public_ssh_key_path != "" ? 0 : 1
  algorithm = "ED25519"
}

resource "local_file" "this" {
  filename = "${path.module}/keys/id_ed25519"
  content  = tls_private_key.this[0].private_key_openssh
  file_permission = "0600"
}