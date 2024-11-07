# --------------------------------------------------
# Cloud Run jobs
# --------------------------------------------------
resource "google_cloud_run_v2_job" "gcs_copy_job" {
  for_each            = { for job in local.gcs_copy_batch_jobs : job.app_name => job }
  name                = each.value.app_name
  location            = var.source_region
  deletion_protection = false
  template {
    task_count  = each.value.task_count
    parallelism = each.value.parallelism
    template {
      service_account = google_service_account.terraform_test_sa.email
      containers {
        image   = "${var.source_region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repository.repository_id}/gcs-backup-job:latest"
        command = each.value.command
        args    = each.value.args
        resources {
          limits = {
            cpu    = each.value.cpu
            memory = each.value.memory
          }
        }
      }
      vpc_access {
        connector = google_vpc_access_connector.connector.id
        egress    = "ALL_TRAFFIC"
      }
      timeout = "3600s"
    }
  }
}
