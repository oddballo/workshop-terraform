terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "owner" {
  type = string
}
variable "profile" {
  type = string
}
variable "region" {
  type = string
}
variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "account_id" {
  type = string
}
variable "name" {
  type = string
}
variable "permissions_boundary" {
  type = string
}
locals {
  prefix = "${var.project}-${var.environment}-${var.profile}"
}

provider "aws" {
  region                  = var.region
  default_tags {
    tags = {
      Owner       = "${var.owner}"
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

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "main.py"
  output_path = "hello-world.zip"
}

resource "aws_lambda_function" "demo" {
  function_name = "${local.prefix}-demo"
  role          = aws_iam_role.demo.arn
  handler       = "main.lambda_handler"
  timeout       = 10
  runtime       = "python3.8"
  filename      = "hello-world.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  depends_on = [
    aws_iam_role_policy_attachment.demo
  ]

  tags = {
    Name = "${local.prefix}-demo"
  }

  environment {
    variables = {
      NAME      = "${var.name}",
      LOG_LEVEL = "INFO"
    }
  }
}

# ****************************
# IAM Roles and Permissions.
# ****************************

resource "aws_iam_role" "demo" {
  name = "${local.prefix}-demo"
  permissions_boundary = var.permissions_boundary

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}


resource "aws_iam_policy" "demo" {
  name        = "${local.prefix}-demo"
  path        = "/"
  description = "IAM policy enabling lambda logging, EC2 instance read access"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${local.prefix}-demo:log-stream:*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "demo" {
  role       = aws_iam_role.demo.name
  policy_arn = aws_iam_policy.demo.arn
}

output "lamba" {
  value = aws_lambda_function.demo.function_name
}
