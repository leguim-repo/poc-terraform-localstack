terraform {
  backend "s3" {
    bucket                      = "s3-terraform-ftm-test"
    key                         = "terraform/terraform.tfstate"
    region                      = "eu-central-1"
    endpoint                    = "http://localhost:4566"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
    dynamodb_table              = "terraformlock"
    dynamodb_endpoint           = "http://localhost:4566"
    encrypt                     = true
  }
}
