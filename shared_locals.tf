locals {
  gcs_copy_batch_jobs = [
    {
      app_name    = "gcs-backup-job"
      command     = ["python", "gcs_backup.py"]
      args        = null
      cpu         = 2.0
      memory      = "2Gi"
      task_count  = 3
      parallelism = 3
    },
  ]
}
