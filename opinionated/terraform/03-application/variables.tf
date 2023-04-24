variable "account_id" {
  type = string
}
variable "bucket_tools" {
  type    = string
  default = ""
}
variable "company" {
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
variable "name" {
  type = string
}
variable "environment" {
  type = string
}
variable "version-demo" {
  type = string
}
locals {
  prefix             = "${var.project}-${var.environment}-${var.profile}"
}

