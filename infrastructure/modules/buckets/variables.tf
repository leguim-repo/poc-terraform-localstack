variable "buckets" {
  default = [{ bucket_name = "bucket_name" }]
}

variable "environment" {
  type    = string
  default = "test"
}

variable "project_name" {
  type    = string
  default = "noname"
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}

variable "lambda_role_execution" {
  type    = string
  default = "lambda_role_execution"
}
