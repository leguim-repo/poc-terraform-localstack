variable "sns_reception_topic" {
  type    = string
  default = "sns_reception_topic"
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
