# --------------------------------------------------
# BigQuery
# --------------------------------------------------
resource "google_bigquery_dataset" "dataset" {
  dataset_id    = "terraform_test_dataset"
  friendly_name = "terraform_test"
  description   = "This is a test dataset."
  location      = var.source_region
}

resource "google_bigquery_table" "users" {
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  table_id            = "users"
  deletion_protection = false
  clustering          = ["user_id"]

  time_partitioning {
    field = "dateday"
    type  = "DAY"
  }

  schema = <<EOF
[
  {
    "name": "user_id",
    "type": "INT64",
    "mode": "REQUIRED",
    "description": "user id"
  },
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "user name"
  },
  {
    "name": "dateday",
    "type": "DATE",
    "mode": "REQUIRED",
    "description": "created date"
  }
]
EOF

}

resource "google_bigquery_dataset" "access_log" {
  dataset_id    = "terraform_test_access_log"
  friendly_name = "terraform test access log"
  description   = "terraform test access log dataset"
  location      = var.source_region
}

resource "google_bigquery_table" "access_log" {
  dataset_id               = google_bigquery_dataset.access_log.dataset_id
  table_id                 = "access_log"
  clustering               = ["timestamp"]
  schema                   = file("access_log_schema/v1.json")
  require_partition_filter = true

  time_partitioning {
    expiration_ms = 31536000000
    type          = "DAY"
    field         = "timestamp"
  }
}
