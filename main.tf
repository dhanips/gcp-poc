provider "google-beta" {
  credentials = file("gke-poc-svc.json")
  project     = "spheric-crowbar-406014"
  region      = "us-west1"

}
module "test-vpc-module"{
    source = "./vpc"
}

module "gke"{
    source = "./gke"
    network = module.test-vpc-module.network_name
    subnetwork = module.test-vpc-module.subnets_names[1]

}
