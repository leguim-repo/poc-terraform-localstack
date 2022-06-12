resource "aws_ssm_parameter" "intake_bucket_name_param" {
  name  = "/${var.project_name}/intake_bucket_name"
  type  = "String"
  value = "${var.intake_bucket_name_value}-${var.project_name}-${var.environment}"
  tags  = var.tags
}

resource "aws_ssm_parameter" "consum_bucket_name_value" {
  name  = "/${var.project_name}/consum_bucket_name"
  type  = "String"
  value = "${var.consum_bucket_name_value}-${var.project_name}-${var.environment}"
  tags  = var.tags
}
