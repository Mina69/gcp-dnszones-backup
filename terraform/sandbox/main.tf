module "cloud-storage" {
  source              = "../modules/cloudstorage"
  gcp_project         = var.gcp_project
  environment         = var.environment
  app_name            = var.app_name
  cloudstorage_labels = {
    labels = merge(var.app_labels, var.team_plattform_labels)
  }
}

module "cloud-build-logs-storage" {
  source              = "../modules/cloudstorage"
  gcp_project         = var.gcp_project
  environment         = var.environment
  app_name            = "cloudbuildlogs-${var.app_name}"
  cloudstorage_labels = {
    labels = merge(var.app_labels, var.team_plattform_labels)
  }
}

module "cloud-build" {
  source                = "../modules/cloudbuild"
  gcp_project           = var.gcp_project
  environment           = var.environment
  app_name              = var.app_name
  bucket_url            = module.cloud-storage.cloud_storage_bucket.url
  schedule_time         = var.schedule_time 
  git_source_repo       = "myrepo" ##bitbucker repo exampel: "bitbucket_myorg_dnszone-backup"
  network_projects_name = var.network_projects_name
  cloudbuild_labels = {
    labels = merge(var.app_labels, var.team_plattform_labels)
  }  
}