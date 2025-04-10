resource "google_dns_managed_zone" "infra_default_fwd_zone" {
  name = "${local.prefix}-infra-peer"
  dns_name = "."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.core.outputs.infra_vpc_id
    }
  }

  peering_config {
    target_network {
      network_url = data.terraform_remote_state.core.outputs.hub_vpc_id
    }
  }
}

resource "google_dns_managed_zone" "infra_pvt_zone" {
  name = "${local.prefix}-infra-zone"
  dns_name = "infra.dns-demo.edu."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.core.outputs.infra_vpc_id
    }
  }
}

resource "google_dns_record_set" "infra_pvt_zone_main" {
   name = "main.${google_dns_managed_zone.infra_pvt_zone.dns_name}"

   type = "A"
   ttl = 300
  
  managed_zone = google_dns_managed_zone.infra_pvt_zone.name
  rrdatas = ["192.168.200.2"]
}
