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
# Variables
# --------------------------------------------------
variable "project_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "source_region" {
  type = string
}

variable "bucket_location" {
  type = string
}