terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta3"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "3.65.0"
    }
  }
  required_version = ">= 1.12.0"
}
