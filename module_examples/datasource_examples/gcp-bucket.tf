# Data Source
data "google_client_config" "client_default" {
}

variable "location"{
  type = string
  default = ""
}

locals{
location = var.location == "" ? data.google_client_config.client_default.region : var.location
project = data.google_client_config.client_default.project
}

resource "google_storage_bucket" "buckets" {
    name          = "mytest-bucket1"
    project       = local.project
    location      = local.location
}