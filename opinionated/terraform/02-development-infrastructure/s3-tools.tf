resource "aws_s3_bucket" "tools" {
  bucket = "${local.prefix}-tools"
  tags = {
    Name = "${local.prefix}-tools"
  }
}

resource "aws_s3_bucket_acl" "tools" {
  bucket = aws_s3_bucket.tools.bucket
  acl    = "private"
}
