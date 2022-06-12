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

provider "archive" {}


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

module "tfbucket" {
  source           = "./modules/tfbucket"
  environment      = local.environment
  tags             = local.tags
  project_name     = local.tags.Project
  terraform_bucket = local.terraform_bucket
}

terraform {
  backend "s3" {
    bucket                      = "s3-terraform-ftm-test"
    key                         = "terraform/terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "http://localhost:4566"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
    dynamodb_table              = "terraformlock"
    dynamodb_endpoint           = "http://localhost:4566"
    encrypt                     = true
  }
}
