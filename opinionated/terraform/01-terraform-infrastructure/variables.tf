variable "region" {
  type = string
}
variable "project" {
  type = string
}
variable "environment" {
  type = string
}
locals {
  prefix = "${var.project}-${var.environment}"
}
