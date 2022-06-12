resource "aws_ssm_parameter" "intake_bucket_name_param" {
  name  = "/${var.project_name}/intake_bucket_name"
  type  = "String"
  value = "${var.intake_bucket_name_value}-${var.project_name}-${var.environment}"
  tags  = var.tags
}
