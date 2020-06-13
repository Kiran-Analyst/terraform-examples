provider "google" {
  version = "3.25.0"

  credentials = file("../../gcp_cred.json")

  project = "practiceproject-248407"
  region  = "us-central1"
  zone    = "us-central1-c"
}