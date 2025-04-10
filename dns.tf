resource "google_dns_managed_zone" "default_fwd_zone" {
  name = "${local.prefix}-default-fwd"
  dns_name = "."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.hub.id
    }
  }

  forwarding_config {
    target_name_servers {
      ipv4_address = google_compute_instance.dns_public_forwarding.network_interface[0].network_ip
    }
  }
}
