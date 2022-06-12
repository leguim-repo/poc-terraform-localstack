output "intake_bucket_name_param" {
  value = aws_ssm_parameter.intake_bucket_name_param.name
}

output "intake_bucket_name_value" {
  value = aws_ssm_parameter.intake_bucket_name_param.value
}
