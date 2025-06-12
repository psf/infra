variable "tags" {
  description = "Tags to apply to all resources as key:value format"
  type        = map(string)
  default     = {}
}

variable "fastly_token" {
  # Used by docs-backend (?)
  description = "Fastly token for synthetics tests"
  type        = string
  sensitive   = true
}

locals {
  synthetics_tags = [for k, v in var.tags : "${k}:${v}"]

  # std locations for all tests, includes all locations available
  standard_locations = [
    "aws:af-south-1",
    "aws:ap-east-1",
    "aws:ap-northeast-1",
    "aws:ap-northeast-2",
    "aws:ap-northeast-3",
    "aws:ap-south-1",
    "aws:ap-southeast-1",
    "aws:ap-southeast-2",
    "aws:ap-southeast-3",
    "aws:ca-central-1",
    "aws:eu-central-1",
    "aws:eu-north-1",
    "aws:eu-south-1",
    "aws:eu-west-1",
    "aws:eu-west-2",
    "aws:eu-west-3",
    "aws:me-south-1",
    "aws:sa-east-1",
    "aws:us-east-1",
    "aws:us-east-2",
    "aws:us-west-1",
    "aws:us-west-2",
    "azure:eastus",
    "gcp:asia-northeast1",
    "gcp:europe-west3",
    "gcp:us-east4",
    "gcp:us-south1",
    "gcp:us-west1",
    "gcp:us-west2"
  ]

  # Reduced locations for some tests (based on imoports we did)
  reduced_locations = [
    "aws:ap-northeast-1",
    "aws:ap-northeast-2",
    "aws:ap-southeast-3",
    "aws:eu-central-1",
    "aws:eu-north-1",
    "aws:eu-west-2",
    "aws:us-east-2",
    "aws:us-west-1",
    "azure:eastus",
    "gcp:us-south1",
    "gcp:us-west1"
  ]

  # default options that most tests share
  default_options = {
    tick_every          = 60
    min_location_failed = 1
    retry_count         = 1
    retry_interval      = 300
  }

  # Standard assertions that most tests use
  standard_assertions = {
    response_time_4000 = {
      type     = "responseTime"
      operator = "lessThan"
      target   = "4000"
    }
    response_time_3000 = {
      type     = "responseTime"
      operator = "lessThan"
      target   = "3000"
    }
    response_time_2000 = {
      type     = "responseTime"
      operator = "lessThan"
      target   = "2000"
    }
    response_time_1000 = {
      type     = "responseTime"
      operator = "lessThan"
      target   = "1000"
    }
    status_200 = {
      type     = "statusCode"
      operator = "is"
      target   = "200"
    }
    status_302 = {
      type     = "statusCode"
      operator = "is"
      target   = "302"
    }
    content_type_html = {
      type     = "header"
      property = "content-type"
      operator = "is"
      target   = "text/html"
    }
    content_type_html_utf8 = {
      type     = "header"
      property = "content-type"
      operator = "is"
      target   = "text/html; charset=utf-8"
    }
  }
}
