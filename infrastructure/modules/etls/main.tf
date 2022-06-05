data "archive_file" "zip" {
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

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256


}

