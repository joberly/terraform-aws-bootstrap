variable "name" {
  type = string
}

variable "environment" {
  type    = string
  default = "bootstrap"
}

variable "spacelift_account_id" {
  description = "Domain name for Spacelift account (e.g., demo.app.spacelift.io)"
  type        = string
}

variable "spacelift_thumbprint" {
  description = "SHA1 fingerprint of Spacelift account server certificate, hex only or colon delimited"
  type        = string
}
