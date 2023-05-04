terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
  backend "s3" {
    encrypt = true
  }
}

provider "aws" {
  region                   = "us-east-1"
  alias                    = "us-east-1"
  default_tags {
    tags = {
      Owner       = "${var.company}"
      Environment = "${var.environment}"
      Project     = "${var.project}"
      Profile     = "${var.profile}"
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

provider "aws" {
  region                   = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  default_tags {
    tags = {
      Owner       = "iig"
      Environment = "${var.environment}"
      Project     = "${var.project}"
      Profile     = "${var.profile}"
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
