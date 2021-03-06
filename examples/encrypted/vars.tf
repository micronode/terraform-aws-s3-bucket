variable "bucket" {
  description = "Name of the S3 bucket"
}

variable "acl" {
  description = "Predefined ACL to apply"
  default     = "private"
}

variable "policy" {
  description = "Identifier for a predefined policy to apply"
  default     = ""
}

variable "suffix_enabled" {
  description = "Indicates whether to append the bucket name with a unique string to prevent conflicts"
  type        = bool
  default     = true
}

variable "expiration_days" {
  description = "Age of bucket objects (days) before they are deleted"
  type        = number
  default     = 0
}

variable "versioned" {
  description = "Enable bucket versioning"
  type        = bool
  default     = false
}

variable "noncurrent_version_expiration" {
  description = "Age of non-current object versions (days) before they are deleted"
  type        = number
  default     = 0
}

variable "encryption_key" {
  description = "The KMS master key used for server-side encryption"
}

variable "logging_bucket" {
  description = "Another S3 bucket used to capture audit logs"
  default     = ""
}

variable "public_read_whitelist" {
  description = "A CIDR IP range for restricted read access to public buckets"
  default     = ""
}

variable "website_redirect" {
  description = "FQDN target for redirect of all website requests"
  default     = ""
}