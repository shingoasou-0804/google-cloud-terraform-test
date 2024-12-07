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

  depends_on = [google_bigquery_table_iam_member.pubsub_sa_bigquery]
}
