output "website_fqdn" {
  description = "Portfolio DNS hostname"
  value       = aws_route53_record.website_a.fqdn
}