# --------------------------------------------------
# BigQuery
# --------------------------------------------------
resource "google_bigquery_dataset" "dataset" {
  dataset_id    = "pubsub_test_dataset"
  friendly_name = "pubsub test dataset"
  description   = "This is a pub/sub test dataset."
  location      = var.source_region
}

resource "google_bigquery_table" "app_logs" {
  dataset_id               = google_bigquery_dataset.dataset.dataset_id
  table_id                 = "pubsub_app_logs"
  deletion_protection      = false
  clustering               = ["user_id"]
  require_partition_filter = true

  time_partitioning {
    type = "DAY"
  }
  schema = <<EOF
[
  {
    "name": "user_id",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": "user id"
  },
  {
    "name": "message",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "message"
  },
  {
    "name": "logged_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": "logged timestamp"
  },
  {
    "name": "created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": "created timestamp",
    "defaultValueExpression": "CURRENT_TIMESTAMP()"
  }
]
EOF

}

resource "google_bigquery_table" "app_logs_deadletter" {
  dataset_id               = google_bigquery_dataset.dataset.dataset_id
  table_id                 = "pubsub_app_logs_deadletter"
  deletion_protection      = false
  clustering               = ["message_id"]
  require_partition_filter = true

  time_partitioning {
    type = "DAY"
  }

  schema = <<EOF
[
  {
    "name": "subscription_name",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "subscription name"
  },
  {
    "name": "message_id",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "message id"
  },
  {
    "name": "publish_time",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": "publish time"
  },
  {
    "name": "data",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "data"
  },
  {
    "name": "attributes",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "attributes"
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
