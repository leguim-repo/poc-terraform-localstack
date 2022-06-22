resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets
  bucket   = "${each.value.bucket_name}-${var.project_name}-${var.environment}"
  force_destroy = true # this flag should be to false for prod environment to avoid destroy tfstate bucket

  lifecycle {
    prevent_destroy = false # this flag should be to true for prod environment to avoid destroy tfstate bucket

  }

  tags = var.tags
}

data "archive_file" "lambda_eventbridge_zip" {
  type        = "zip"
  source_file = "../app/etls/lambda_eventbridge/src/lambda_eventbridge.py"
  output_path = "lambda_eventbridge.zip"
}
resource "aws_lambda_function" "lambda_eventbridge" {
  function_name                  = "lambda_eventbridge-${var.project_name}-${var.environment}"
  description                    = "Lambda eventbridge"
  role                           = var.lambda_role_execution
  tags                           = var.tags
  handler                        = "lambda_eventbridge.lambda_handler"
  runtime                        = "python3.8"
  memory_size                    = 128
  timeout                        = 900
  reserved_concurrent_executions = 1
  package_type                   = "Zip"

  filename         = data.archive_file.lambda_eventbridge_zip.output_path
  source_code_hash = data.archive_file.lambda_eventbridge_zip.output_base64sha256

}
resource "aws_cloudwatch_log_group" "lambda_eventbridge" {
  retention_in_days = 7
  tags              = var.tags
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}


resource "aws_cloudwatch_event_rule" "s3_eventbridge" {
  name          = "${var.buckets.eventbridge.bucket_name}-rule"
  event_pattern = <<EOF
                  {
                    "source": ["aws.s3"],
                    "detail-type": ["Object Created"],
                    "detail": {
                      "bucket": {
                        "name": ["${var.buckets.eventbridge.bucket_name}-${var.project_name}-${var.environment}"]
                      },
                      "object": {
                        "key": [{
                          "prefix": "upload/"
                        }]
                      }
                    }
                  }
                EOF

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "s3_eventbridge_lambda" {
  event_bus_name = "default"
  rule           = aws_cloudwatch_event_rule.s3_eventbridge.name
  arn            = aws_lambda_function.lambda_eventbridge.arn
  role_arn       = var.lambda_role_execution
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
