terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    encrypt = true
  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  default_tags {
    tags = {
      Owner       = "iig"
      Environment = "${var.environment}"
      Project     = "${var.project}"
    }
  }
  ignore_tags {
    keys = [
      "AutoTag_CreateTime",
      "AutoTag_Creator",
      "AutoTag_UserName"
    ]
  }
}

