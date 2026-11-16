variable "domain_name" {
  description = "Hostname covered by the certificate"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID for DNS validation"
  type        = string
}