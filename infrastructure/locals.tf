locals {
  environment = "test"

  tags = {
    created_by  = "Mike"
    Environment = local.environment
    Project     = "fundaciontonymanero"
  }

}
