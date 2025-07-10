terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
      configuration_aliases = [aws.source, aws.destination]

    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  alias  = "source"
  region = var.source_region
}

provider "aws" {
  alias  = "destination"
  region = var.destination_region
}
