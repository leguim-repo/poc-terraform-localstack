variable "intake_bucket_name_value" {
  type    = string
  default = "intake_bucket_name_value"
}

variable "consum_bucket_name_value" {
  type    = string
  default = "consum_bucket_name_value"
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
