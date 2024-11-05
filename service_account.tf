# --------------------------------------------------
# Service account
# --------------------------------------------------
resource "google_service_account" "terraform_test_sa" {
  account_id   = "terraform-test-service-account"
  display_name = "terraform_test_service_account"
}

# --------------------------------------------------
# IAM role
# --------------------------------------------------
resource "google_project_iam_member" "gcs_access" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.terraform_test_sa.email}"
}
