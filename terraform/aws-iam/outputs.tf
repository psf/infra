output "role_arns" {
  description = "Map of IAM role names to ARNs"
  value = {
    datadog_integration = aws_iam_role.datadog_integration.arn
    organization_access = aws_iam_role.organization_access.arn
  }
}

output "group_arns" {
  description = "Map of IAM group names to ARNs"
  value = {
    admin = aws_iam_group.admin.arn
    kops  = aws_iam_group.kops.arn
  }
}
