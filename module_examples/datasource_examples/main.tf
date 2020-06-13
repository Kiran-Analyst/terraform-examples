data "google_project" "project" {
    project_id = "practiceproject-248407"
}
 
data "google_service_account" "myaccount" {
  account_id = "projectowner"
}

data "google_client_config" "default" {
}

output "project_number" {
  value = data.google_project.project.number
}

output "project_name" {
  value = data.google_project.project.name
}

output "project_details" {
  value = data.google_project.project
}

output "service_account_details" {
  value = data.google_service_account.myaccount
}

output "google_client_config_details" {
    value = data.google_client_config.default
}