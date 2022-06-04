output "intake_bucket" {
  value = aws_s3_bucket.intake_bucket.arn
}

output "consum_bucket" {
  value = aws_s3_bucket.consum_bucket.arn
}
