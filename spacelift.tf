# Spacelift OIDC connection

locals {
  spacelift_thumbprint = replace(var.spacelift_thumbprint, ":", "")
}

resource "aws_iam_openid_connect_provider" "joberly_app_spacelift_io" {
  url = "https://${var.spacelift_account_id}"

  client_id_list = [
    var.spacelift_account_id,
  ]

  thumbprint_list = [
    local.spacelift_thumbprint,
  ]
}
