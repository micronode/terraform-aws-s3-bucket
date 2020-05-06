variable "bucket_name" {
  description = "Name of the S3 bucket"
}

variable "suffix_enabled" {
  description = "Indicates whether to append the bucket name with a unique string to prevent conflicts"
  type        = bool
  default     = false
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

variable "encrypted" {
  description = "Enable server-side encryption"
  type        = bool
  default     = false
}

variable "encryption_key" {
  description = "The KMS master key used for server-side encryption"
  default     = ""
}
