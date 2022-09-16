variable "gcp_project" {
  description = "To determine GCP app project id"
}

variable "cloudbuild_labels" {
  description = "To determine application name and environment"
  type = object({
    labels = map(string)
  })
}

variable "region" {
  description = "GCP default region"
  default     = "europe-west1"
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

variable "bucket_url" {
  description = "To determine the bucket url for storing DNS backup"
  type        = string
}

variable "tags" {
  description = "Tags to apply on resources"
  type        = list
  default     = ["platform", "dnszonebackup"]
}

variable "schedule_time" {
  description = "Time for running backup on DNS records"
  type        = string 
}

variable "git_source_repo" {
  description = "To determine the name of git source repository"
  type        = string
}

variable "network_projects_name" {
  description = "To determine name of the network projectes that have DNS zones and records"
  default     = {}
}    
