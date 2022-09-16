variable "gcp_project" {
  description = "To determine GCP project id"
}

variable "app_name" {
  description = "To determine application name"
  type        = string
}
variable "cloudstorage_labels" {
  description = "To determine application name and environment"
  type = object({
    labels = map(string)
  })
}
variable "name_override" {
  description = "Set to override the default bucket name. Follows contentions; setting it to 'foo' in dev will result in the bucket being named 'demo-gcs-foo-dev-001'"
  type        = string
  default     = null
}

variable "environment" {
  description = "Name of environment to create storage resource on it"
  type        = string
}

variable "force_destroy" {
  description = "Whether to allow Terraform to delete the bucket even if it contains objects."
  type        = bool
  default     = false
}

variable "storage_purpose" {
  description = "The purpose of the storage bucket. Determines storage class."
  type        = string
  default     = "standard"
}

variable "versioning" {
  description = "Whether to enable object versioning."
  type        = bool
  default     = true
}

variable "versioned_object_retention_days" {
  description = "The number of days to keep old versions of changed or deleted files. Only takes effect if 'versioning' is enabled"
  type        = number
  default     = 2
}

variable "lifecycle_rules_override" {
  description = "The bucket's Lifecycle Rules configuration. Will override the 'versioned_object_retention_days' setting."
  type = map(object({
    action = object({
      type = string
    })
    condition = map(string)
  }))
  default = null
  validation {
    condition     = var.lifecycle_rules_override == null || can([for rule in var.lifecycle_rules_override : rule.action.type != null && rule.condition != null])
    error_message = "Every lifecycle rule must have an 'action.type', and contain a 'condition', or be 'null'."
  }
}