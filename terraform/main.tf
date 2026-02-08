provider "google" {
  project = "vmware-env-413614"
  region  = "asia-south1"
  zone    = "asia-south1-a"
}

resource "google_compute_network" "vpc" {
  name                    = "db-devops-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "db-devops-subnet"
  region        = "asia-south1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_compute_firewall" "allow_ssh_http" {
  name    = "allow-ssh-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

#cloud router
resource "google_compute_router" "router" {
  name    = "db-devops-router"
  network = google_compute_network.vpc.id
  region  = "asia-south1"
}

#cloud nat
resource "google_compute_router_nat" "nat" {
  name                               = "db-devops-nat"
  router                             = google_compute_router.router.name
  region                             = "asia-south1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


resource "google_compute_instance" "vm" {
  name         = "db-devops-vm"
  machine_type = "e2-medium"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
/*
    access_config {
    }
*/
  }

  tags = ["devops-vm"]
}

