terraform {
  backend "gcs" {
    bucket = "demo-gcs-tfa-dnsbackup"
    prefix = "gcp/team-platform/dnszone-backup/prd"
  }
}

provider "google" {
  project     = var.gcp_project
  region      = var.region
  zone        = var.zone
}