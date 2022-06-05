variable "intake_bucket" {
  type    = string
  default = "intake"
}

variable "consum_bucket" {
  type    = string
  default = "consum"
}

variable "lambda_role_execution" {
  type    = string
  default = "lambda_role_execution"
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
