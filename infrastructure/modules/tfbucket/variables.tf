variable "terraform_bucket" {
  type    = string
  default = "terraform"
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
