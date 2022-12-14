resource "aws_lambda_function" "demo" {
  function_name = "${local.prefix}-demo"
  role          = aws_iam_role.demo.arn
  handler       = "main.lambda_handler"
  timeout       = 10
  runtime       = "python3.8"
  s3_bucket     = var.bucket_tools != "" ? var.bucket_tools : aws_s3_bucket.tools.bucket
  s3_key        = "demo.${var.version-demo}.zip"

  depends_on = [
    aws_iam_role_policy_attachment.demo,
    aws_cloudwatch_log_group.demo,
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
# Cloudwatch related
# ****************************

resource "aws_lambda_permission" "demo_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.demo_trigger.arn
}

resource "aws_cloudwatch_log_group" "demo" {
  name              = "/aws/lambda/${local.prefix}-demo"
  retention_in_days = 14
}

resource "aws_cloudwatch_event_rule" "demo_trigger" {
  name        = "${local.prefix}-demo_trigger"
  description = "Fires every time an EC2 state changes to running."
  schedule_expression = "rate(12 hours)"
}

resource "aws_cloudwatch_event_target" "demo_target" {
  rule = aws_cloudwatch_event_rule.demo_trigger.name
  arn  = aws_lambda_function.demo.arn
}

# ****************************
# IAM Roles and Permissions.
# ****************************

resource "aws_iam_role" "demo" {
  name = "${local.prefix}-demo"

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
