# --------------------------------------------------
# Cloud Scheduler job
# --------------------------------------------------
resource "google_cloud_scheduler_job" "gcs_copy_scheduler" {
  for_each  = { for job in local.gcs_copy_batch_jobs : job.app_name => job }
  name      = "${each.value.app_name}_scheduler"
  schedule  = "0 11 * * *"
  time_zone = "Asia/Tokyo"

  retry_config {
    max_backoff_duration = "60s"
    max_doublings        = 2
    max_retry_duration   = "10s"
    min_backoff_duration = "1s"
    retry_count          = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.gcs_copy_job[each.value.app_name].location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.project.number}/jobs/${google_cloud_run_v2_job.gcs_copy_job[each.value.app_name].name}:run"
    oauth_token {
      service_account_email = google_service_account.terraform_test_sa.email
    }
  }
}
