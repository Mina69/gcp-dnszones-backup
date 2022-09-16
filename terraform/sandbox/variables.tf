variable "gcp_project" {
  description = "To determine GCP app project id"
}

variable "region" {
  description = "GCP default region"
  default     = "europe-west1"
}

variable "zone" {
  description = "GCP default zone"
  default     = "europe-west1-d"
}

variable "app_labels" {
  description = "labels used in all resources"
  type        = map
  default = {}
}

variable "team_plattform_labels" {
  description = "Labels for team plattform infrastructure"
  type        = map
  default = {
    team  = "platform"
    slack = "mychannel"
  }
}

variable "environment" {
  description = "To determine name of environment to create storage resource on it"
  type        = string
}

variable "app_name" {
  description = "To determine application name"
  type        = string
  default     = "dnszones-backup"
}

variable "schedule_time" {
  description = "To determine time for running backup on DNS records"
  type        = string
}

variable "network_projects_name" {
  default = {
    sbx = {
      name = "demo-networks-sbx-001"
    }
  }
}   