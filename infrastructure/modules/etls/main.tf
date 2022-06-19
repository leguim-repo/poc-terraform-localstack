data "archive_file" "zip" {
  type        = "zip"
  source_file = "../app/etls/lambda_dummy/src/lambda_dummy.py"
  output_path = "lambda_dummy.zip"
}
resource "aws_lambda_function" "lambda_dummy" {
  function_name                  = "lambda_dummy-${var.project_name}-${var.environment}"
  description                    = "Lambda dummy"
  role                           = var.lambda_role_execution
  tags                           = var.tags
  handler                        = "lambda_dummy.lambda_handler"
  runtime                        = "python3.8"
  memory_size                    = 128
  timeout                        = 900
  reserved_concurrent_executions = 1
  package_type                   = "Zip"

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  environment {
    variables = {
      greeting = "Hello is in os.environ"
    }
  }
}
resource "aws_cloudwatch_log_group" "lambda_dummy" {
  retention_in_days = 7
  tags              = var.tags
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}


data "archive_file" "lambda_intake_zip" {
  type        = "zip"
  source_file = "../app/etls/lambda_intake/src/lambda_intake.py"
  output_path = "lambda_intake.zip"
}
resource "aws_lambda_function" "lambda_intake" {
  function_name                  = "lambda_intake-${var.project_name}-${var.environment}"
  description                    = "Lambda data intake"
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
resource "aws_cloudwatch_log_group" "lambda_intake" {
  retention_in_days = 7
  tags              = var.tags
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}
##### S3 Notifications
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification

## Lambda triggered when file upload
resource "aws_s3_bucket_notification" "s3_lambda_on_upload" {
  bucket = var.buckets_created.intake
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_intake.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "pictures/"
    filter_suffix       = ".jpeg"
  }
}
