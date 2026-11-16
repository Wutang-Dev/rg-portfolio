output "state_bucket_name" {
  description = "Name of the Terraform state bucket."
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "ARN of the Terraform state bucket."
  value       = aws_s3_bucket.terraform_state.arn
}

output "bootstrap_backend_config" {
  description = "Backend settings for bootstrap state migration."

  value = <<-EOT
    bucket       = "${aws_s3_bucket.terraform_state.id}"
    key          = "bootstrap/terraform.tfstate"
    region       = "${var.aws_region}"
    encrypt      = true
    use_lockfile = true
  EOT
}

output "infra_backend_config" {
  description = "Backend settings for the portfolio infrastructure."

  value = <<-EOT
    bucket       = "${aws_s3_bucket.terraform_state.id}"
    key          = "infra/terraform.tfstate"
    region       = "${var.aws_region}"
    encrypt      = true
    use_lockfile = true
  EOT
}
output "website_deploy_role_arn" {
  description = "IAM role assumed by the website deployment workflow"
  value       = aws_iam_role.website_deploy.arn
}
output "infra_plan_role_arn" {
  description = "IAM role assumed by infrastructure planning jobs"
  value       = aws_iam_role.infra_plan.arn
}
output "infra_apply_role_arn" {
  description = "IAM role assumed by infrastructure apply jobs"
  value       = aws_iam_role.infra_apply.arn
}