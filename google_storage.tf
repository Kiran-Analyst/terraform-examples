locals{
    roles = {
        "OWNER" = google_service_account.bqowner.email
        "READER" = "hashicorp.com"
    }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "example_dataset"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "EU"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }
  
//   dynamic "access" {
//       iterator = name1
//       for_each = local.roles
//       content {
        
//         role          = name1.key
//         user_by_email = name1.value
//       }
//   }

//   for_each = local.roles
//   access {
//     role   = "READER"
//     domain = "hashicorp.com"
//   }

//   access {
//     role   = "OWNER"
//     domain = "google_service_account.bqowner.email"
//   }
}

resource "google_bigquery_dataset_access" "access" {
  
  dataset_id    = google_bigquery_dataset.dataset.dataset_id
  for_each = local.roles
  role          = each.key
  user_by_email = each.value
}

// resource "google_bigquery_dataset_access" "access" {
//   dataset_id    = google_bigquery_dataset.dataset.dataset_id
//   role          = "OWNER"
//   user_by_email = google_service_account.bqowner.email
// }

resource "google_service_account" "bqowner" {
  account_id = "bqowner"
}