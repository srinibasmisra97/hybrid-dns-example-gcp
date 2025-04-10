resource "google_compute_network" "hub" {
  name                    = "${local.prefix}-hub"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dns_subnet" {
  name          = "${google_compute_network.hub.name}-sbn"
  network       = google_compute_network.hub.self_link
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_firewall" "hub_vpc_allow_iap" {
  name          = "${google_compute_network.hub.name}-allow-iap"
  network       = google_compute_network.hub.self_link
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
}

resource "google_compute_firewall" "hub_vpc_allow_dns" {
  name          = "${google_compute_network.hub.name}-allow-dns"
  network       = google_compute_network.hub.self_link
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


resource "google_compute_firewall" "hub_allow_internal" {
  name          = "${google_compute_network.hub.name}-allow-internal"
  network       = google_compute_network.hub.self_link
  source_ranges = ["10.0.0.0/24","10.0.10.0/24","10.0.20.0/24"]
  allow {
    protocol = "all"
  }
}

resource "google_compute_router" "router" {
  name    = "${google_compute_network.hub.name}-router"
  network = google_compute_network.hub.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "${google_compute_network.hub.name}-nat"
  router                             = google_compute_router.router.name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}

resource "google_compute_network_peering" "hub_to_app" {
  name = "${local.prefix}-hub-to-app"
  network = google_compute_network.hub.self_link
  peer_network = google_compute_network.app.self_link
}

resource "google_compute_network_peering" "hub_to_infra" {
  name = "${local.prefix}-hub-to-infra"
  network = google_compute_network.hub.self_link
  peer_network = google_compute_network.infra.self_link
}
