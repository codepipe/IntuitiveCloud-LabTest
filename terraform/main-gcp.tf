
# Create a VPC
resource "google_compute_network" "example_vpc" {
  name                    = "example-vpc"
  auto_create_subnetworks = false
}

# Create public and private subnets
resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  network       = google_compute_network.example_vpc.self_link
  ip_cidr_range = "10.40.0.0/24" # Adjust the CIDR block as needed
  region        = "us-central1"  # Adjust the region as needed
}

resource "google_compute_subnetwork" "private_subnet_1" {
  name          = "private-subnet-1"
  network       = google_compute_network.example_vpc.self_link
  ip_cidr_range = "10.40.1.0/24" # Adjust the CIDR block as needed
  region        = "us-central1"  # Adjust the region as needed
}

resource "google_compute_subnetwork" "private_subnet_2" {
  name          = "private-subnet-2"
  network       = google_compute_network.example_vpc.self_link
  ip_cidr_range = "10.40.2.0/24" # Adjust the CIDR block as needed
  region        = "us-central1"  # Adjust the region as needed
}

# Create a public IP address
resource "google_compute_address" "public_ip" {
  name = "public-ip"
}

# Create a firewall rule to allow SSH traffic
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.example_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a Linux VM instance template
resource "google_compute_instance_template" "example_template" {
  name        = "example-vm-template"
  description = "Example VM template"

  tags = ["http-server", "https-server"]

  machine_type = "e2-micro"

  disk {
    source_image = "projects/debian-cloud/global/images/debian-10-buster-v20220314"
    auto_delete  = true
  }

  network_interface {
    network = google_compute_network.example_vpc.name
    subnetwork = google_compute_subnetwork.public_subnet.name
    access_config {
      nat_ip = google_compute_address.public_ip.address
    }
  }

  metadata = {
    ssh-keys = "your-ssh-key" # Replace with your SSH public key
  }
}

# Create instances based on the template
resource "google_compute_instance" "example_instance" {
  count             = 2
  name              = "example-instance-${count.index}"
  instance_template = google_compute_instance_template.example_template.self_link

  boot_disk {
    initialize_params {
      size = 100
    }
  }
}

# Attach instances to public subnet
resource "google_compute_instance_group" "example_instance_group" {
  name        = "example-instance-group"
  description = "Example instance group"
  instances = [
    google_compute_instance.example_instance[0].self_link,
    google_compute_instance.example_instance[1].self_link,
  ]
  named_port {
    name = "http"
    port = 80
  }
}

