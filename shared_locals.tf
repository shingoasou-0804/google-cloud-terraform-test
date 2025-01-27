locals {
  services = toset([
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
  ])

  google_cloud_backup_batch_jobs = [
    {
      app_name    = "google-cloud-backup"
      command     = ["python", "main.py"]
      args        = ["hoge", "fuga"]
      cpu         = 1.0
      memory      = "512Mi"
      task_count  = 2
      parallelism = 2
    },
  ]
}
