provider "google" {
  version = "3.25.0"
  credentials = file("../gcp_cred.json")
  project = "practiceproject-248407"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "cloud-storage" {
//   source  = "terraform-google-modules/cloud-storage/google"
  source  = "./gcs-bucket"
//   version = "1.5.0"
  # insert the 3 required variables here
  names = ["bucket1", "bucket2"]
  prefix = "test-kiran"
  project_id = "practiceproject-248407"
}

output "bucket-names"{
    description = "names of the buckets created"
    value = module.cloud-storage.bucket_name
}