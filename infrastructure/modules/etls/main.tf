data "archive_file" "lambda_intake_zip" {
  type        = "zip"
  source_file = "../app/etls/lambda_intake/src/lambda_intake.py"
  output_path = "lambda_intake.zip"
}

resource "aws_lambda_function" "lambda_intake" {
  function_name                  = "lambda_intake"
  role                           = var.lambda_role_execution
  tags                           = var.tags
  handler                        = "lambda_intake.lambda_handler"
  runtime                        = "python3.8"
  memory_size                    = 128
  timeout                        = 900
  reserved_concurrent_executions = 1
  package_type                   = "Zip"

  filename         = data.archive_file.lambda_intake_zip.output_path
  source_code_hash = data.archive_file.lambda_intake_zip.output_base64sha256


}

##### S3 Notifications
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification

## Lambda on file upload
resource "aws_s3_bucket_notification" "s3_lambda_on_upload" {
  bucket = var.intake_bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_intake.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "pictures/"
    filter_suffix       = ".jpeg"
  }

}
