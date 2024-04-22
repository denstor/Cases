terraform {
  backend "gcs" {
    bucket = "240419-bucket-terraform"
    prefix = "state"
  }
}

provider "google" {
  project = "terraform-420806"
}