output "buckets_created" {
  value = tomap({
  for k, inst in aws_s3_bucket.buckets : k => inst.id
  })
}

