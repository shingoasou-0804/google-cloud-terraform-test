# --------------------------------------------------
# Cloud Pub/Sub
# --------------------------------------------------
resource "google_pubsub_schema" "access_log_schema_v1" {
  name       = "${var.project_name}-access-log-v1"
  type       = "AVRO"
  definition = file("access_log_schema/v1.avsc")
}

resource "google_pubsub_topic" "access_log_v1" {
  name = "${var.project_name}-access-log-v1"

  schema_settings {
    schema   = google_pubsub_schema.access_log_schema_v1.id
    encoding = "BINARY"
  }
}

resource "google_pubsub_subscription" "access_log_v1_bq" {
  name                       = "${var.project_name}-access-log-v1-bq"
  topic                      = google_pubsub_topic.access_log_v1.id
  ack_deadline_seconds       = 10
  message_retention_duration = "604800s"

  bigquery_config {
    table               = "${var.project_id}:${google_bigquery_table.access_log.dataset_id}.${google_bigquery_table.access_log.table_id}"
    use_topic_schema    = true
    write_metadata      = false
    drop_unknown_fields = true
  }

  depends_on = [google_bigquery_table_iam_member.pubsub_sa_bigquery_access_log]
}

resource "google_pubsub_schema" "app_log_schema_v2" {
  name       = "${var.project_name}-app-log-v2"
  type       = "AVRO"
  definition = file("access_log_schema/pubsubtestv2.avsc")
}

resource "google_pubsub_topic" "app_log_v2" {
  name = "${var.project_name}-app-log-v2"

  schema_settings {
    schema   = google_pubsub_schema.app_log_schema_v2.id
    encoding = "JSON"
  }
}

resource "google_pubsub_subscription" "app_log_v2_bq" {
  name  = "${var.project_name}-app-log-v2-bq"
  topic = google_pubsub_topic.app_log_v2.id

  bigquery_config {
    table            = "${var.project_id}:${google_bigquery_table.app_logs.dataset_id}.${google_bigquery_table.app_logs.table_id}"
    use_topic_schema = true
  }

  depends_on = [google_bigquery_table_iam_member.pubsub_sa_bigquery_app_logs]

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.app_log_deadletter_v1.id
    max_delivery_attempts = 5
  }
}

resource "google_pubsub_topic" "app_log_deadletter_v1" {
  name = "${var.project_name}-app-log-deadletter-v1"
}

resource "google_pubsub_subscription" "app_log_deadletter_v1_bq" {
  name  = "${var.project_name}-app-log-deadletter-v1-bq"
  topic = google_pubsub_topic.app_log_deadletter_v1.id

  bigquery_config {
    table          = "${var.project_id}:${google_bigquery_table.app_logs_deadletter.dataset_id}.${google_bigquery_table.app_logs_deadletter.table_id}"
    write_metadata = true
  }

  depends_on = [
    google_bigquery_table_iam_member.pubsub_sa_bigquery_app_logs_deadletter
  ]
}
