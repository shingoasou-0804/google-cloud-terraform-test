# --------------------------------------------------
# Terraform Backend
# --------------------------------------------------
terraform {
  backend "gcs" {
    bucket = "terraform-test-oshin-drone"
    prefix = "terraform/state"
  }
}

# --------------------------------------------------
# Provider
# --------------------------------------------------
provider "google" {
  project = var.project_id
  region  = var.source_region
}

# --------------------------------------------------
# API enable
# --------------------------------------------------
resource "google_project_service" "enable_api" {
  for_each                   = local.services
  project                    = var.project_id
  service                    = each.value
  disable_dependent_services = true
}

# --------------------------------------------------
# Data
# --------------------------------------------------
data "google_project" "project" {}

# --------------------------------------------------
# Variables
# --------------------------------------------------
variable "project_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "source_region" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "bucket_location" {
  type = string
}

variable "github_repository" {
  type = string
}

variable "github_org" {
  type = string
}

variable "github_telemetry_repo" {
  type = string
}
