# Terraformer role with permissions boundary and assume role policy which
# allows Spacelift account access.

resource "aws_iam_role" "terraformer" {
  name        = "terraformer"
  description = "Role for Terraforming"

  assume_role_policy = data.aws_iam_policy_document.terraformer_assume_role.json

  permissions_boundary = aws_iam_policy.terraformer_permissions_boundary.arn
}

resource "aws_iam_policy" "terraformer_permissions_boundary" {
  name        = "terraformer-permissions-boundary"
  path        = "/"
  description = "Permissions boundary for the terraformer role"

  policy = data.aws_iam_policy_document.terraformer_permissions_boundary.json
}

data "aws_iam_policy_document" "terraformer_assume_role" {
  statement {
    sid    = "AllowAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.joberly_app_spacelift_io.arn,
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.spacelift_account_id}:aud"
      values = [
        var.spacelift_account_id,
      ]
    }
  }
}

data "aws_iam_policy_document" "terraformer_permissions_boundary" {
  statement {
    sid    = "DenyAccountAdmin"
    effect = "Deny"
    actions = [
      "account:CloseAccount",
      "account:DeleteAlternateContact",
      "account:DisableRegion",
      "account:EnableRegion",
      "account:PutAlternateContact",
      "account:PutChallengeQuestions",
      "account:PutContactInformation",
      "billing:*",
    ]
    resources = [
      "*",
    ]
  }

  statement {
    sid    = "EnforcePermissionsBoundary"
    effect = "Allow"
    actions = [
      "iam:AddUserToGroup",
      "iam:AttachRolePolicy",
      "iam:AttachUserPolicy",
      "iam:CreateRole",
      "iam:CreateUser",
      "iam:DeleteRolePolicy",
      "iam:DeleteUserPolicy",
      "iam:DetachRolePolicy",
      "iam:DetachUserPolicy",
      "iam:PutRolePermissionsBoundary",
      "iam:PutRolePolicy",
      "iam:PutUserPermissionsBoundary",
      "iam:PutUserPolicy",
      "iam:UpdateAssumeRolePolicy",
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values = [
        "awsarn:aws:iam::144363388242:policy/terraformer-permissions-boundary",
      ]
    }
  }
}
