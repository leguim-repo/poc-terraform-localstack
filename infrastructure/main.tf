terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "3.50.0" # fail with localstasck and sns -> https://githubmemory.com/repo/localstack/localstack/issues/4321
      version = "3.29.0"
    }
  }

  required_version = ">= 0.14.9"
}

module "roles" {
  source       = "./modules/roles"
  environment  = local.environment
  tags         = local.tags
  project_name = local.tags.Project
}

module "buckets" {
  source        = "./modules/buckets"
  environment   = local.environment
  tags          = local.tags
  project_name  = local.tags.Project
  intake_bucket = local.intake_bucket
  consum_bucket = local.consum_bucket
}

provider "archive" {}
data "archive_file" "zip" {
  type        = "zip"
  source_file = "../app/etls/lambda_dummy/src/lambda_dummy.py"
  output_path = "lambda_dummy.zip"
}

resource "aws_lambda_function" "lambda_dummy" {
  function_name                  = "lambda_dummy"
  role                           = module.roles.lambda_role
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

module "sns" {
  source                = "./modules/sns"
  environment           = local.environment
  tags                  = local.tags
  project_name          = local.tags.Project
  sns_reception_topic   = local.sns_reception_topic
  lambda_role_execution = module.roles.lambda_role
  depends_on            = [module.roles.lambda_role]
}

module "etls" {
  source                = "./modules/etls"
  environment           = local.environment
  tags                  = local.tags
  project_name          = local.tags.Project
  lambda_role_execution = module.roles.lambda_role
  intake_bucket         = module.buckets.intake_bucket
  consum_bucket         = module.buckets.consum_bucket
  depends_on            = [module.roles.lambda_role, module.buckets]
}
