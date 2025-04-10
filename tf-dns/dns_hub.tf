resource "google_dns_managed_zone" "default_fwd_zone" {
  name = "${local.prefix}-default-fwd"
  dns_name = "."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.core.outputs.hub_vpc_id
    }
  }

  forwarding_config {
    target_name_servers {
      ipv4_address = data.terraform_remote_state.core.outputs.root_dns_server_ip
    }
  }
}

resource "google_dns_managed_zone" "hub_app_fwd_zone" {
  name = "${local.prefix}-hub-app-fwd"
  dns_name = "app.dns-demo.edu."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.core.outputs.hub_vpc_id
    }
  }

  peering_config {
    target_network {
      network_url = data.terraform_remote_state.core.outputs.app_vpc_id
    }
  }
}

resource "google_dns_managed_zone" "hub_infra_fwd_zone" {
  name = "${local.prefix}-hub-infra-fwd"
  dns_name = "infra.dns-demo.edu."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.core.outputs.hub_vpc_id
    }
  }

  peering_config {
    target_network {
      network_url = data.terraform_remote_state.core.outputs.infra_vpc_id
    }
  }
}


resource "google_dns_managed_zone" "hub_pvt_zone" {
  name = "${local.prefix}-hub-zone"
  dns_name = "dns-demo.edu."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.terraform_remote_state.core.outputs.hub_vpc_id
    }
  }
}

resource "google_dns_record_set" "hub_pvt_zone_main" {
   name = "main.${google_dns_managed_zone.hub_pvt_zone.dns_name}"

   type = "A"
   ttl = 300
  
  managed_zone = google_dns_managed_zone.hub_pvt_zone.name
  rrdatas = ["192.168.10.2"]
}
