module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "wizeline-academy-k8s-36bd66a7"
  name                       = "gke-academy-1"
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = "academy-vpc"
  subnetwork                 = "academy-subnet"
  ip_range_pods              = "academy-subnet-range-pods"
  ip_range_services          = "academy-subnet-range-services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true
  remove_default_node_pool   = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-2"
      min_count          = 1
      max_count          = 3
      local_ssd_count    = 0
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      academy-gke-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "academy-gke-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "academy-gke-node-pool",
    ]
  }
}