# --------------------------------------------------
# Workload Identity Pool
# --------------------------------------------------
resource "google_iam_workload_identity_pool" "terraform_test_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "${var.project_name}-pool"
  display_name              = "${var.project_name}-pool"
  description               = "GitHub Actionsで使用"
}

# --------------------------------------------------
# Workload Identity Pool Provider
# --------------------------------------------------
resource "google_iam_workload_identity_pool_provider" "terraform_test_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.terraform_test_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "${var.project_name}-provider"
  display_name                       = "${var.project_name}-provider"
  description                        = "GitHub Actionsで使用"

  attribute_mapping = {
    "google.subject"             = "assertion.sub",
    "attribute.actor"            = "assertion.actor",
    "attribute.repository"       = "assertion.repository",
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository_owner == '${var.github_org}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}
