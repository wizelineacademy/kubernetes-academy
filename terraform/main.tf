terraform {
  backend "gcs" {
    bucket  = "academy-infra"
    prefix  = "terraform/state"
  }
}

resource "google_compute_network" "academy-vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  project                 = var.project_id
}

resource "google_compute_subnetwork" "academy-subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr_range
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.academy-vpc.self_link
  secondary_ip_range {
    range_name    = var.pods_range_name
    ip_cidr_range = var.pods_cidr_range
  }
  secondary_ip_range {
    range_name    = var.services_range_name
    ip_cidr_range = var.services_cidr_range
  }
}

resource "google_project_iam_member" "academy_group" {
  project = "wizeline-academy-k8s-36bd66a7"
  role    = "roles/viewer"
  member  = "group:kubernetes-academy@wizeline.com"
}

resource "google_project_iam_member" "academy_group_k8s_viewer" {
  project = var.project_id
  role    = "roles/container.clusterViewer"
  member  = "group:kubernetes-academy@wizeline.com"
}

resource "google_project_iam_member" "academy_group_k8s_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "group:${var.academy_google_group}"
}

resource "google_compute_firewall" "gke-academy-nodes" {
  project = var.project_id
  name    = "gke-academy-nodes-services"
  network = google_compute_network.academy-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
  description   = "Allows k8s services of type NodePort to be reachable from the internet."
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-gke-academy-1"]
}