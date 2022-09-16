resource "google_service_account" "cloudbuild_service_account" {
  account_id = "${var.app_name}-${var.gcp_project}"
}

resource "google_cloudbuild_trigger" "main" {
  name            = "demo-gcb-${var.gcp_project}-${var.app_name}"
  project         = var.gcp_project 
  source_to_build {
    uri       = "https://source.developers.google.com/p/${var.gcp_project}/r/${var.git_source_repo}"
    ref       = "refs/heads/master"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
  }

  git_file_source {
    path      = "scripts/cloudbuild.yaml"
    uri       = "https://source.developers.google.com/p/${var.gcp_project}/r/${var.git_source_repo}"
    revision  = "refs/heads/master"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
  }
  
  service_account = google_service_account.cloudbuild_service_account.id
  tags            = var.tags 
  substitutions   = {
    _PROJECT_NAMES: join(",", [for k, v in var.network_projects_name: v.name])
    _BUCKET_URL: var.bucket_url
  }
  
}

###Assigning required roles to service account###
resource "google_project_iam_member" "act_as" {
  project = var.gcp_project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "logs_writer" {
  project = var.gcp_project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "storage_admin" {
  project = var.gcp_project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "dns_reader" {
  for_each = var.network_projects_name
  project  = each.value.name
  role     = "roles/dns.reader"
  member   = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_custom_role" "custom_roles" {
  role_id     = "cloudbuild_custom_roles"
  title       = "Access to source repository and creating build"
  description = "Access to source repository and creating build"
  permissions = ["source.repos.get", "source.repos.list", "cloudbuild.builds.create"]
}

resource "google_project_iam_member" "custom_roles" {
  project = var.gcp_project
  role    = google_project_iam_custom_role.custom_roles.name
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

##Scheduling job for running cloudbuild-DNS backup everyday###
resource "google_cloud_scheduler_job" "nightly" {
  project = var.gcp_project
  region  = var.region
  name    = "demo-gcsj-cloudbuildscheduler-${var.gcp_project}-${var.app_name}"

  schedule  = var.schedule_time 
  time_zone = "Europe/Amsterdam"

  attempt_deadline = "120s"

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/projects/${var.gcp_project}/triggers/${google_cloudbuild_trigger.main.trigger_id}:run"

    oauth_token {
      service_account_email = google_service_account.cloudbuild_service_account.email
    }
  }
}
