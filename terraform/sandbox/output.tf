output "cloudbuild_name" {
    value = module.cloud-build.cloudbuild_trigger.name
}

output "service_account_email" {
    value = module.cloud-build.cloudbuild_trigger.service_account
}

output "backup_storage_name" {
    value = module.cloud-storage.cloud_storage_bucket.name
}