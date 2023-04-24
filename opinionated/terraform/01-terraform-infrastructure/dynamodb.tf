resource "aws_dynamodb_table" "terraform_lock" {
  name           = "${local.prefix}-terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}

