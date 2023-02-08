# State bucket - private and encrypted

locals {
  bucket_name = "${var.name}-terraform-state"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name

  tags = {
    Name                      = local.bucket_name
    Environment               = var.environment
    terraform-module          = "terraform-aws-bootstrap"
    terraform-module-name     = var.name
    terraform-module-resource = "terraform_state"
  }
}

resource "aws_kms_key" "terraform_state" {
  description             = "Encryption of Terraform state"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "terraform_state" {
  name          = "alias/terraform-state"
  target_key_id = aws_kms_key.terraform_state.key_id
}

resource "aws_s3_bucket_acl" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_alias.terraform_state.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
