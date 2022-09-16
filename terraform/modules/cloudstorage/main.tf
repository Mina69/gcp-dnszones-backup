locals {
  bucket_shortname = var.name_override != null ? var.name_override : "${var.gcp_project}-${var.app_name}"
  bucket_name      = "demo-gcs-${local.bucket_shortname}"
  storage_purpose = {
    standard = {
      location      = "EUROPE-WEST1"
      storage_class = "STANDARD"
    }
  }
  default_lifecycle = {
    max_object_versions = {
      action = {
        type = "Delete"
      }
      condition = {
        with_state                 = "ARCHIVED"
        days_since_noncurrent_time = var.versioned_object_retention_days
      }
    }
  }
}

resource "google_storage_bucket" "main" {
  name          = local.bucket_name
  project       = var.gcp_project
  location      = local.storage_purpose[var.storage_purpose].location
  force_destroy = var.force_destroy
  storage_class = local.storage_purpose[var.storage_purpose].storage_class


  labels                      = var.cloudstorage_labels.labels
  uniform_bucket_level_access = true

  versioning {
    enabled = var.versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules_override != null ? var.lifecycle_rules_override : local.default_lifecycle
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = try(lifecycle_rule.value.action.storage_class, null)
      }
      condition {
        age                        = try(lifecycle_rule.value.condition.age, null)
        created_before             = try(lifecycle_rule.value.condition.created_before, null)
        with_state                 = try(lifecycle_rule.value.condition.with_state, null)
        matches_storage_class      = try(lifecycle_rule.value.condition.matches_storage_class, null)
        num_newer_versions         = try(lifecycle_rule.value.condition.num_newer_versions, null)
        custom_time_before         = try(lifecycle_rule.value.condition.custom_time_before, null)
        days_since_noncurrent_time = try(lifecycle_rule.value.condition.days_since_noncurrent_time, null)
        noncurrent_time_before     = try(lifecycle_rule.value.condition.noncurrent_time_before, null)
      }
    }
  }
}