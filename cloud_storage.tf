# --------------------------------------------------
# Cloud Storage destination bucket
# --------------------------------------------------
resource "google_storage_bucket" "destination_bucket" {
  name          = var.bucket_name
  location      = var.bucket_location
  storage_class = "STANDARD"
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}
