output "bucket-intake" {
  value = aws_s3_bucket.bucket-intake.arn
}

output "bucket-consum" {
  value = aws_s3_bucket.bucket-consum.arn
}
