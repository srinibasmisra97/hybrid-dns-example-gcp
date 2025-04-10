output "hub_vpc_id" {
  value = google_compute_network.hub.id
}

output "app_vpc_id" {
  value = google_compute_network.app.id
}

output "infra_vpc_id" {
  value = google_compute_network.infra.id
}

output "root_dns_server_ip" {
  value = google_compute_instance.dns_public_forwarding.network_interface[0].network_ip
}
