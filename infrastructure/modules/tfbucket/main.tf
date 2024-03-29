resource "aws_s3_bucket" "terraform_bucket" {
  bucket        = "${var.terraform_bucket}-${var.project_name}-${var.environment}"
  tags          = var.tags
  acl           = "private"
  force_destroy = true # this flag should be to false for prod environment to avoid destroy tfstate bucket

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = false # this flag should be to true for prod environment to avoid destroy tfstate bucket

  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_access" {
  bucket                  = aws_s3_bucket.terraform_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

#resource "aws_dynamodb_table" "terraform_state_lock" {
#  name           = "terraformlock"
#  read_capacity  = 0
#  write_capacity = 0
#  billing_mode   = "PAY_PER_REQUEST"
#  hash_key       = "LockID"
#
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#}
