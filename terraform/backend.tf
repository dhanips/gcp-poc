terraform {
  backend "gcs" {
    bucket  = "poc-test-bkt-tf"
    prefix  = "terraform/state"
  }
}
