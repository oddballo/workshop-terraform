output "bucket-tools" {
  value = var.bucket_tools != "" ? var.bucket_tools : aws_s3_bucket.tools.bucket
}
output "region" {
  value = var.region
}
output "prefix" {
  value = local.prefix
}
