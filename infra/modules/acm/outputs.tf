output "certificate_arn" {
  description = "ARN of the validated website certificate"
  value       = aws_acm_certificate_validation.website.certificate_arn
}
