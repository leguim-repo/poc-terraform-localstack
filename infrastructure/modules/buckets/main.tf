resource "aws_s3_bucket" "intake_bucket" {
  bucket = "${var.intake_bucket}-${var.project_name}-${var.environment}"
  tags   = var.tags
}

resource "aws_s3_bucket" "consum_bucket" {
  bucket = "${var.consum_bucket}-${var.project_name}-${var.environment}"
  tags   = var.tags
}

##### S3 Notifications
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification

## Lambda on file upload
#resource "aws_s3_bucket_notification" "s3_lambda_on_upload" {
#  bucket = module.s3.this_s3_bucket_id
#
#  lambda_function {
#    lambda_function_arn = module.lambda_function.this_lambda_function_arn
#    events              = ["s3:ObjectCreated:*"]
#    filter_prefix       = "input/"
#    filter_suffix       = ".zip"
#  }
#}
