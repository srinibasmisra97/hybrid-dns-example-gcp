resource "google_compute_network" "infra" {
  name                    = "${local.prefix}-infra"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "infra_subnet" {
  name          = "${google_compute_network.infra.name}-sbn"
  network       = google_compute_network.infra.self_link
  ip_cidr_range = "10.0.20.0/24"
}

resource "google_compute_firewall" "infra_vpc_allow_iap" {
  name          = "${google_compute_network.infra.name}-allow-iap"
  network       = google_compute_network.infra.self_link
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
}

resource "google_compute_firewall" "infra_vpc_allow_dns" {
  name          = "${google_compute_network.infra.name}-allow-dns"
  network       = google_compute_network.infra.self_link
  source_ranges = ["35.199.192.0/19"]
  allow {
    protocol = "tcp"
    ports    = ["53"]
  }
  allow {
    protocol = "udp"
    ports = ["53"]
  }
}


resource "google_compute_firewall" "infra_allow_internal" {
  name          = "${google_compute_network.infra.name}-allow-internal"
  network       = google_compute_network.infra.self_link
  source_ranges = ["10.0.0.0/24","10.0.10.0/24","10.0.20.0/24"]
  allow {
    protocol = "all"
  }
}

resource "google_compute_network_peering" "infra_to_hub" {
  name = "${local.prefix}-infra-to-hub"
  network = google_compute_network.infra.self_link
  peer_network = google_compute_network.hub.self_link
}
