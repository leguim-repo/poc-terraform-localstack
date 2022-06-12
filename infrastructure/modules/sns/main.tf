data "archive_file" "lambda_sns_subscriber_zip" {
  type        = "zip"
  source_file = "../app/sns/lambda_sns_subscriber/src/lambda_sns_subscriber.py"
  output_path = "lambda_sns_subscriber.zip"
}

resource "aws_lambda_function" "lambda_sns_subscriber" {
  function_name                  = "lambda_sns_subscriber"
  description                    = "Lambda SNS Subscriber"
  role                           = var.lambda_role_execution
  handler                        = "lambda_sns_subscriber.lambda_handler"
  runtime                        = "python3.8"
  memory_size                    = 128
  timeout                        = 900
  reserved_concurrent_executions = 1000
  package_type                   = "Zip"

  filename         = data.archive_file.lambda_sns_subscriber_zip.output_path
  source_code_hash = data.archive_file.lambda_sns_subscriber_zip.output_base64sha256

  environment {

  }
}
resource "aws_cloudwatch_log_group" "lambda_sns_subscriber" {
  retention_in_days = 7
  tags              = var.tags
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_sns_topic" "lambda_sns_subscriber" {
  name         = "${var.sns_reception_topic }-${var.project_name}-${var.environment}"
  display_name = "${var.sns_reception_topic }-${var.project_name}-${var.environment}"
  tags         = var.tags
}

resource "aws_sns_topic_subscription" "invoke_by_sns" {
  topic_arn              = aws_sns_topic.lambda_sns_subscriber.arn
  protocol               = "lambda"
  endpoint               = aws_sns_topic.lambda_sns_subscriber.arn
  endpoint_auto_confirms = false
}

resource "aws_lambda_permission" "allow_sns_invoke_lambda" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_sns_subscriber.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.lambda_sns_subscriber.arn
}


