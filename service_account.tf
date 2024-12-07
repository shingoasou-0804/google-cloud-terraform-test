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
# IAM role for artifact_registry_writer
# --------------------------------------------------
resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.terraform_test_sa.email}"
}

# --------------------------------------------------
# IAM role for cloud_run_jobs_developer
# --------------------------------------------------
resource "google_project_iam_member" "cloud_run_jobs_developer" {
  project = var.project_id
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.terraform_test_sa.email}"
}

# --------------------------------------------------
# IAM role for cloud_build_builds_editor
# --------------------------------------------------
resource "google_project_iam_member" "cloud_build_builds_editor" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"
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

# --------------------------------------------------
# IAM role for workload_identity_pool_user
# --------------------------------------------------
resource "google_project_iam_member" "workload_identity_pool_user" {
  project = var.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.terraform_test_pool.name}/attribute.repository/${var.github_repository}"
}

# --------------------------------------------------
# Allows Cloud Pub/Sub service acccount to push BigQuery Dataset
# --------------------------------------------------
resource "google_project_service_identity" "pubsub" {
  provider = google-beta
  project  = var.project_id
  service  = "pubsub.googleapis.com"
}

resource "google_bigquery_table_iam_member" "pubsub_sa_bigquery" {
  dataset_id = google_bigquery_table.access_log.dataset_id
  table_id   = google_bigquery_table.access_log.table_id
  for_each   = toset(["roles/bigquery.metadataViewer", "roles/bigquery.dataEditor"])
  role       = each.key
  member     = "serviceAccount:${google_project_service_identity.pubsub.email}"
}
