

resource "google_compute_network" "vpc_network" {
  name = "terraform-network-2"
  description = "Test second Terraform network"
  count = 1
}

output "ip_address" {
  value = "${google_compute_network.vpc_network.*.id[0]}"
}