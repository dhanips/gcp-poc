variable "project_id" {
  type = string
  default = "spheric-crowbar-406014"
  description = "The project ID to host the network in"
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = ""
}

variable "region" {
  type = string
  default = "us-west1"
  description = "The region to host the cluster in"
}

variable "network" {
  description = "The VPC network to host the cluster in"
}

variable "subnetwork" {
#   type    = string
#   default = element(var.subnetwork, random(length(var.subnetwork)))

# #   default = "subnet-01"
  description = "The subnetwork to host the cluster in"
}


variable "ip_range_pods" {
  default = ""
  description = "The secondary ip range to use for pods"
}

variable "ip_range_services" {
  default = ""
  description = "The secondary ip range to use for services"
}

variable "compute_engine_service_account" {
  type = string
  default = "poc-471@spheric-crowbar-406014.iam.gserviceaccount.com"
  description = "Service account to associate to the nodes in the cluster"
}