locals {
  environment = "test"

  intake_bucket = "s3-intake"
  consum_bucket = "s3-consum"

  sns_reception_topic = "sns-reception-topic"

  tags = {
    created_by  = "Mike"
    Environment = local.environment
    Project     = "fundaciontonymanero"
  }

}
