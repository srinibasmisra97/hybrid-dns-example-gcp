resource "google_compute_instance" "dns_public_forwarding" {
  name         = "${local.prefix}-dns-root"
  machine_type = "n1-standard-1"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.hub.self_link
    subnetwork = google_compute_subnetwork.dns_subnet.self_link
    network_ip = "10.0.0.2"
  }
  metadata_startup_script = file("../configs/install.sh")
}

resource "google_compute_instance" "dns_apps" {
  name         = "${local.prefix}-apps"
  machine_type = "n1-standard-1"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.app.self_link
    subnetwork = google_compute_subnetwork.app_subnet.self_link
    network_ip = "10.0.10.3"
  }
}

 resource "google_compute_instance" "dns_infra" {
   name         = "${local.prefix}-dns-infra"
   machine_type = "n1-standard-1"
   boot_disk {
     initialize_params {
       image = "ubuntu-os-cloud/ubuntu-2204-lts"
     }
   }

   network_interface {
     network    = google_compute_network.infra.self_link
     subnetwork = google_compute_subnetwork.infra_subnet.self_link
     network_ip = "10.0.20.2"
   }
 }

