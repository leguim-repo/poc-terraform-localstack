resource "aws_s3_bucket" "bucket-intake" {
  bucket = format("s3-intake-%s-%s", var.project_name, var.environment)
  tags   = var.tags

}

resource "aws_s3_bucket" "bucket-consum" {
  bucket = format("s3-consum-%s-%s", var.project_name, var.environment)
  tags   = var.tags

}
