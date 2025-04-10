resource "google_dns_managed_zone" "app_default_fwd_zone" {
  name = "${local.prefix}-app-peer"
  dns_name = "."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.core.outputs.app_vpc_id
    }
  }

  peering_config {
    target_network {
      network_url = data.terraform_remote_state.core.outputs.hub_vpc_id
    }
  }
}

resource "google_dns_managed_zone" "app_pvt_zone" {
  name = "${local.prefix}-app-zone"
  dns_name = "app.dns-demo.edu."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.core.outputs.app_vpc_id
    }
  }
}

resource "google_dns_record_set" "app_pvt_zone_main" {
   name = "main.${google_dns_managed_zone.app_pvt_zone.dns_name}"

   type = "A"
   ttl = 300
  
  managed_zone = google_dns_managed_zone.app_pvt_zone.name
  rrdatas = ["192.168.100.2"]
}
