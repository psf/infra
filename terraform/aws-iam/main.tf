# Data source to get current AWS account info
data "aws_caller_identity" "current" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.0"
    }
  }
  required_version = ">= 1.1.8"
}

# IAM Groups
resource "aws_iam_group" "admin" {
  name = "admin"
  path = "/"
}

resource "aws_iam_group" "kops" {
  name = "kops"
  path = "/"
}

# ===========================
# Group Memberships
# ===========================

resource "aws_iam_group_membership" "admin" {
  name  = "admin-membership"
  group = aws_iam_group.admin.name
  users = [
    "ee",
    "coffee"
  ]
}

resource "aws_iam_group_membership" "kops" {
  name  = "kops-membership"
  group = aws_iam_group.kops.name
  users = [
    "kops"
  ]
}

# org access (?)
resource "aws_iam_role" "organization_access" {
  name = "OrganizationAccountAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::220435833635:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ===========================
# Role Policy Attachments
# ===========================

resource "aws_iam_role_policy_attachment" "organization_access_admin" {
  role       = aws_iam_role.organization_access.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ===========================
# Group Policy Attachments
# ===========================

resource "aws_iam_group_policy_attachment" "admin_administrator_access" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "kops_route53" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_ec2" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_iam" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_sqs" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_vpc" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_s3" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_eventbridge" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}
