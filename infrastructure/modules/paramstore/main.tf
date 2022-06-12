resource "aws_ssm_parameter" "intake_bucket_name" {
  name  = "/${var.project_name}/${var.intake_bucket_name}"
  type  = "String"
  value = var.intake_bucket_name_value
  tags  = var.tags
}
