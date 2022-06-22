locals {
  environment = "test"

  terraform_bucket = "s3-terraform"

  buckets = {
    "intake"      = { bucket_name = "s3-intake" },
    "consum"      = { bucket_name = "s3-consum" },
    "eventbridge" = { bucket_name = "s3-intake-eventbridge" },
  }

  sns_reception_topic = "sns-reception-topic"

  tags = {
    created_by  = "Mike"
    Environment = local.environment
    Project     = "ftm"
  }

}
