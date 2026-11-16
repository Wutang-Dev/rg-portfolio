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