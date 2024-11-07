# --------------------------------------------------
# Service account
# --------------------------------------------------
resource "google_service_account" "terraform_test_sa" {
  account_id   = "terraform-test-service-account"
  display_name = "terraform_test_service_account"
}

# --------------------------------------------------
# Service account key
# --------------------------------------------------
resource "google_service_account_key" "terraform_test_sa_key" {
  service_account_id = google_service_account.terraform_test_sa.name
}

# --------------------------------------------------
# Save the service account key to local file
# --------------------------------------------------
resource "local_file" "terraform_test_sa_key" {
  filename             = "terraform_test_sa_key.json"
  content              = base64decode(google_service_account_key.terraform_test_sa_key.private_key)
  file_permission      = "0600"
  directory_permission = "0755"
}

# --------------------------------------------------
# IAM role for gcs_access
# --------------------------------------------------
resource "google_project_iam_member" "gcs_access" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.terraform_test_sa.email}"
}

# --------------------------------------------------
# IAM role for artifact_registry_admin
# --------------------------------------------------
resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.terraform_test_sa.email}"
}

# --------------------------------------------------
# IAM role for cloud_run_jobs_admin
# --------------------------------------------------
resource "google_project_iam_member" "cloud_run_jobs_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.terraform_test_sa.email}"
}

# --------------------------------------------------
# IAM role for cloud_run_jobs_viewer
# --------------------------------------------------
resource "google_project_iam_member" "cloud_run_jobs_viewer" {
  project = var.project_id
  role    = "roles/run.viewer"
  member  = "serviceAccount:${google_service_account.terraform_test_sa.email}"
}

# --------------------------------------------------
# IAM role for service_account_user
# --------------------------------------------------
resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.terraform_test_sa.email}"
}
