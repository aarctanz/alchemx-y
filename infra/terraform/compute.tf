resource "google_compute_address" "gateway-internal" {
  name         = "alchemx-gateway-internal"
  subnetwork   = google_compute_subnetwork.private.id
  address_type = "INTERNAL"
  address      = "10.10.1.10"
  region       = var.region
}

resource "google_compute_instance" "gateway" {
  name         = "alchemx-gateway"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.id
    network_ip = google_compute_address.gateway-internal.address
    access_config {

    }
  }
  metadata_startup_script = file("${path.module}/../startup/gateway.sh")
  tags                    = ["gateway"]

}


resource "google_compute_instance" "caller-worker" {
  name = "alchemx-caller-worker"

  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.id
  }
  tags = ["worker"]

}

resource "google_compute_instance" "inference-worker" {
  name = "alchemx-inference-worker"

  machine_type = "e2-standard-4"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 30
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.id
  }

  tags = ["worker"]
}
