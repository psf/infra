# variable "aws_access_key_id" {
# type      = string
# sensitive = true
# }
# variable "aws_secret_access_key" {
# type      = string
# sensitive = true
# }

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog Application key"
  sensitive   = true
}

variable "fastly_token" {
  type        = string
  description = "Fastly token for synthetics tests"
  sensitive   = true
}

terraform {
  cloud {
    organization = "psf"
    workspaces {
      name = "psf-infra"
    }
  }
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}


provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
