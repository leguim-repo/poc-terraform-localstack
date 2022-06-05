data "archive_file" "lambda_sns_subscriber_zip" {
  type        = "zip"
  source_file = "../app/sns/lambda_sns_subscriber/src/lambda_sns_subscriber.py"
  output_path = "lambda_sns_subscriber.zip"
}

resource "aws_lambda_function" "lambda_sns_subscriber" {
  function_name                  = "lambda_sns_subscriber"
  description                    = "Lambda SNS Subscriber"
  filename                       = data.archive_file.lambda_sns_subscriber_zip.output_path
  source_code_hash               = data.archive_file.lambda_sns_subscriber_zip.output_base64sha256
  role                           = var.lambda_role_execution
  handler                        = "lambda_sns_subscriber.lambda_handler"
  runtime                        = "python3.8"
  reserved_concurrent_executions = 1
}

resource "aws_sns_topic" "lambda_sns_subscriber" {
  name         = "${var.sns_reception_topic }-${var.project_name}-${var.environment}"
  display_name = "${var.sns_reception_topic }-${var.project_name}-${var.environment}"
  tags         = var.tags
}

resource "aws_sns_topic_subscription" "invoke_by_sns" {
  topic_arn = aws_sns_topic.lambda_sns_subscriber.arn
  protocol  = "lambda"
  endpoint = aws_sns_topic.lambda_sns_subscriber.arn
  endpoint_auto_confirms = false
}

resource "aws_lambda_permission" "allow_sns_invoke_lambda" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_sns_subscriber.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.lambda_sns_subscriber.arn
}


