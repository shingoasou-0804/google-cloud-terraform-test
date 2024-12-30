# --------------------------------------------------
# Compute network
# --------------------------------------------------
resource "google_compute_network" "vpc_network" {
  name = "${var.project_name}-vpc"
}

# --------------------------------------------------
# Vpc access connector
# --------------------------------------------------
resource "google_vpc_access_connector" "connector" {
  name          = "${var.project_name}-connector"
  region        = var.source_region
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.vpc_network.id
  min_instances = 2
  max_instances = 3
}
