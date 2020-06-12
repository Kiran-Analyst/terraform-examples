resource "google_storage_bucket" "buckets" {
    for_each = var.names
    name          = "${var.prefix}${each.value}"
    project       = var.project_id
    location      = var.location
}