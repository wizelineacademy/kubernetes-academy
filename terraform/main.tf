resource "google_compute_network" "academy-vpc" {
  name = "academy-vpc"
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
  project = "wizeline-academy-k8s-36bd66a7"
}

resource "google_compute_subnetwork" "academy-subnet" {
  name          = "academy-subnet"
  ip_cidr_range = "10.2.0.0/16"
  project       = "wizeline-academy-k8s-36bd66a7"
  region        = "us-central1"
  network       = google_compute_network.academy-vpc.self_link
  secondary_ip_range {
    range_name    = "academy-subnet-range-pods"
    ip_cidr_range = "172.16.24.0/22"
  }
  secondary_ip_range {
    range_name    = "academy-subnet-range-services"
    ip_cidr_range = "172.16.28.0/22"
  }
}

