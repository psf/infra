# ===========================
# Datadog Integration
# ===========================

resource "aws_iam_role" "datadog_integration" {
  name = "DatadogIntegrationRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::464622532012:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "384add1455db419a9cc641427f2c640f"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "datadog_integration" {
  name = "DatadogIntegrationPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "apigateway:GET",
          "autoscaling:Describe*",
          "backup:List*",
          "backup:ListRecoveryPointsByBackupVault",
          "bcm-data-exports:GetExport",
          "bcm-data-exports:ListExports",
          "budgets:ViewBudget",
          "cassandra:Select",
          "cloudfront:GetDistributionConfig",
          "cloudfront:ListDistributions",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus",
          "cloudtrail:LookupEvents",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "codedeploy:BatchGet*",
          "codedeploy:List*",
          "cur:DescribeReportDefinitions",
          "directconnect:Describe*",
          "dynamodb:Describe*",
          "dynamodb:List*",
          "ec2:Describe*",
          "ec2:GetSnapshotBlockPublicAccessState",
          "ec2:GetTransitGatewayPrefixListReferences",
          "ec2:SearchTransitGatewayRoutes",
          "ecs:Describe*",
          "ecs:List*",
          "elasticache:Describe*",
          "elasticache:List*",
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeTags",
          "elasticloadbalancing:Describe*",
          "elasticmapreduce:Describe*",
          "elasticmapreduce:List*",
          "es:DescribeElasticsearchDomains",
          "es:ListDomainNames",
          "es:ListTags",
          "events:CreateEventBus",
          "fsx:DescribeFileSystems",
          "fsx:ListTagsForResource",
          "glacier:GetVaultNotifications",
          "glue:ListRegistries",
          "health:DescribeAffectedEntities",
          "health:DescribeEventDetails",
          "health:DescribeEvents",
          "kinesis:Describe*",
          "kinesis:List*",
          "lambda:GetPolicy",
          "lambda:List*",
          "lightsail:GetInstancePortStates",
          "logs:DeleteSubscriptionFilter",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:DescribeSubscriptionFilters",
          "logs:FilterLogEvents",
          "logs:PutSubscriptionFilter",
          "logs:TestMetricFilter",
          "oam:ListAttachedLinks",
          "oam:ListSinks",
          "organizations:Describe*",
          "organizations:List*",
          "rds:Describe*",
          "rds:List*",
          "redshift:DescribeClusters",
          "redshift:DescribeLoggingStatus",
          "route53:List*",
          "s3:GetBucketLocation",
          "s3:GetBucketLogging",
          "s3:GetBucketNotification",
          "s3:GetBucketTagging",
          "s3:ListAccessGrants",
          "s3:ListAllMyBuckets",
          "s3:PutBucketNotification",
          "savingsplans:DescribeSavingsPlanRates",
          "savingsplans:DescribeSavingsPlans",
          "ses:Get*",
          "sns:GetSubscriptionAttributes",
          "sns:List*",
          "sns:Publish",
          "sqs:ListQueues",
          "states:DescribeStateMachine",
          "states:ListStateMachines",
          "support:DescribeTrustedAdvisor*",
          "support:RefreshTrustedAdvisorCheck",
          "tag:GetResources",
          "tag:GetTagKeys",
          "tag:GetTagValues",
          "timestream:DescribeEndpoints",
          "waf-regional:ListRuleGroups",
          "waf-regional:ListRules",
          "waf:ListRuleGroups",
          "waf:ListRules",
          "wafv2:GetIPSet",
          "wafv2:GetLoggingConfiguration",
          "wafv2:GetRegexPatternSet",
          "wafv2:GetRuleGroup",
          "wafv2:ListLoggingConfigurations",
          "xray:BatchGetTraces",
          "xray:GetTraceSummaries"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "datadog_integration" {
  role       = aws_iam_role.datadog_integration.name
  policy_arn = aws_iam_policy.datadog_integration.arn
}
