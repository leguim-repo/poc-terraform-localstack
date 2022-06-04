terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

module "buckets" {
  source        = "./modules/buckets"
  environment   = local.environment
  tags          = local.tags
  project_name  = local.tags.Project
  intake_bucket = local.intake_bucket
  consum_bucket = local.intake_bucket
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "../app/etls/lambda_dummy/src/lambda_dummy.py"
  output_path = "lambda_dummy.zip"
}

resource "aws_lambda_function" "lambda_dummy" {
  function_name = "lambda_dummy"

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  role                           = aws_iam_role.iam_for_lambda.arn
  handler                        = "lambda_dummy.lambda_handler"
  runtime                        = "python3.8"
  reserved_concurrent_executions = 1

  environment {
    variables = {
      greeting = "Hello is in os.environ"
    }
  }
}

module "sns" {
  source                = "./modules/sns"
  environment           = local.environment
  tags                  = local.tags
  project_name          = local.tags.Project
  sns_reception_topic   = local.sns_reception_topic
  lambda_role_execution = aws_iam_role.iam_for_lambda.arn
  depends_on            = [aws_iam_role.iam_for_lambda]
}
