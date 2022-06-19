resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets
  bucket   = "${each.value.bucket_name}-${var.project_name}-${var.environment}"
  tags     = var.tags

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
