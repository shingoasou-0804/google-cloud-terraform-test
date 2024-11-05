# --------------------------------------------------
# Artifact Registry
# --------------------------------------------------
resource "google_artifact_registry_repository" "repository" {
  location      = var.source_region
  repository_id = "terraform-test-repo"
  format        = "DOCKER"
}
