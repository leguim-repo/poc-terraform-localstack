output "intake_bucket" {
  value = aws_s3_bucket.intake_bucket.id
}

output "consum_bucket" {
  value = aws_s3_bucket.consum_bucket.id
}
