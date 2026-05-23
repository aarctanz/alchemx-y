resource "google_compute_firewall" "allow-api" {
  name    = "alchemx-allow-api"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = [3111]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gateway"]
}


resource "google_compute_firewall" "allow-internal" {
  name    = "alchemx-allow-internal"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.10.1.0/24"]

}

resource "google_compute_firewall" "allow-ssh-iap" {
  name    = "alchemx-allow-ssh-iap"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = ["35.235.240.0/20"]
}
