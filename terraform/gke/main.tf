locals {
  cluster_type = "simple-regional-private"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  project = var.project_id
  region  = var.region
}

module "gke" {
  source                    = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                = var.project_id
  name                      = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                  = true
  region                    = var.region
  network                   = var.network
  subnetwork                = var.subnetwork
  ip_range_pods             = var.ip_range_pods
  ip_range_services         = var.ip_range_services
  create_service_account    = false
  service_account           = var.compute_engine_service_account
  enable_private_endpoint   = true
  enable_private_nodes      = true
  master_ipv4_cidr_block    = "172.16.0.0/28"
#   add_cluster_firewall_rules = true
#   firewall_inbound_ports     = ["9443", "15017", "443", "80", "22"]
  default_max_pods_per_node = 100
  remove_default_node_pool  = true
  deletion_protection       = false

  node_pools = [
    {
      name              = "pool-01"
      min_count         = 1
      max_count         = 2
      local_ssd_count   = 0
      disk_size_gb      = 20
      disk_type         = "pd-standard"
      auto_repair       = true
      auto_upgrade      = true
      service_account   = var.compute_engine_service_account
      preemptible       = false
      max_pods_per_node = 100
    },
  ]
  master_authorized_networks = [
    {
      cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
      display_name = "VPC"
    },
  ]
}

# google_client_config and kubernetes provider must be explicitly specified like the following.
# data "google_client_config" "default" {}

# provider "kubernetes" {
#   host                   = "https://${module.gke.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
# }

# module "gke" {
#   source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
#   project_id                 = var.project_id
#   name                       = "gke-test-1"
#   region                     = "us-west1"
#   zones                      = ["us-west1-a", "us-west1-b", "us-west1-f"]
#   network                    = var.network
#   subnetwork                 = var.subnetwork
#   ip_range_pods              = ""
#   ip_range_services          = ""
#   http_load_balancing        = false
#   network_policy             = false
#   horizontal_pod_autoscaling = true
#   filestore_csi_driver       = false
#   enable_private_endpoint    = true
#   enable_private_nodes       = true
#   master_ipv4_cidr_block     = "10.0.0.0/28"

#   node_pools = [
#     {
#       name                      = "default-node-pool"
#       machine_type              = "e2-medium"
#       node_locations            = "us-west-b,us-west-c"
#       min_count                 = 1
#       max_count                 = 100
#       local_ssd_count           = 0
#       spot                      = false
#       disk_size_gb              = 30
#       disk_type                 = "pd-standard"
#       image_type                = "COS_CONTAINERD"
#       enable_gcfs               = false
#       enable_gvnic              = false
#       logging_variant           = "DEFAULT"
#       auto_repair               = true
#       auto_upgrade              = true
#       service_account           = var.compute_engine_service_account
#       preemptible               = false
#       initial_node_count        = 2
#     },
    
#   ]

#   node_pools_oauth_scopes = {
#     all = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#     ]
#   }

#   node_pools_labels = {
#     all = {}

#     default-node-pool = {
#       default-node-pool = true
#     }
#   }

#   node_pools_metadata = {
#     all = {}

#     default-node-pool = {
#       node-pool-metadata-custom-value = "my-node-pool"
#     }
#   }

#   node_pools_taints = {
#     all = []

#     default-node-pool = [
#       {
#         key    = "default-node-pool"
#         value  = true
#         effect = "PREFER_NO_SCHEDULE"
#       },
#     ]
#   }

#   node_pools_tags = {
#     all = []

#     default-node-pool = [
#       "default-node-pool",
#     ]
#   }
# }