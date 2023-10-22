# Variables
variable "yc_token" {
  default = "t1.9euelZrGzpaOyZORm4-Pyo6Nm5Gake3rnpWayYqej5KOk4mYl5mTkZqQnpfl8_c5NytW-e8aU0wm_N3z93llKFb57xpTTCb8zef1656VmsyZyJmVi46Ym53IicacnYmb7_zF656VmsyZyJmVi46Ym53IicacnYmb.Jq4YnnA9ZBR7ah0D9UPKPUFrEAVDMPQewsRINyrNWWQLhbycniIjLbn941hkgdzHlXCFviGKwBl9h8y-Pty4Bw"
}
variable "yc_cloud_id" {
  default = "b1gkjk5reuc4u9svu54m"
}
variable "yc_folder_id" {
  default = "b1gj45vv7fpc7kmc184h"
}
variable "yc_zone" {
  default = "ru-central1-a"
} 

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone = var.yc_zone
}

# Bucket
resource "yandex_iam_service_account" "sa-bucket" {
  name        = "sa-bucket"
}
resource "yandex_resourcemanager_folder_iam_member" "roleassignment-storageeditor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
}
resource "yandex_iam_service_account_static_access_key" "accesskey-bucket" {
  service_account_id = yandex_iam_service_account.sa-bucket.id
}
resource "yandex_storage_bucket" "listopad-netology" {
  access_key = yandex_iam_service_account_static_access_key.accesskey-bucket.access_key
  secret_key = yandex_iam_service_account_static_access_key.accesskey-bucket.secret_key
  bucket     = "listopad-netology"
  default_storage_class = "STANDARD"
  acl           = "public-read"
  force_destroy = "true"
  anonymous_access_flags {
    read = true
    list = true
    config_read = true
  }
}
resource "yandex_storage_object" "netology" {
  access_key = yandex_iam_service_account_static_access_key.accesskey-bucket.access_key
  secret_key = yandex_iam_service_account_static_access_key.accesskey-bucket.secret_key
  bucket     = yandex_storage_bucket.listopad-netology.id
  key        = "netology.png"
  source     = "netology.png"
}

# VPC
resource "yandex_vpc_network" "network-netology" {
  name = "network-netology"
}

# Public subnet
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-netology.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Private subnet
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-netology.id
  route_table_id = yandex_vpc_route_table.netology-routing.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

# Routing table
resource "yandex_vpc_route_table" "netology-routing" {
  name       = "netology-routing"
  network_id = yandex_vpc_network.network-netology.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

# Instance group for network load balancer
resource "yandex_iam_service_account" "sa-group" {
  name        = "sa-group"
}
resource "yandex_resourcemanager_folder_iam_member" "roleassignment-editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-group.id}"
}
resource "yandex_compute_instance_group" "group-nlb" {
  name               = "group-nlb"
  folder_id          = var.yc_folder_id
  service_account_id = "${yandex_iam_service_account.sa-group.id}"
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.network-netology.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
    }
    metadata = {
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      user-data = "#!/bin/bash\n cd /var/www/html\n echo \"<html><h1>The netology web-server with a network load balancer.</h1><img src='https://${yandex_storage_bucket.listopad-netology.bucket_domain_name}/${yandex_storage_object.netology.key}'></html>\" > index.html"
    }
    labels = {
      group = "group-nlb"
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  allocation_policy {
    zones = [var.yc_zone]
  }
  deploy_policy {
    max_unavailable = 2
    max_expansion   = 1
  }
  load_balancer {
    target_group_name = "target-nlb"
  }
  health_check {
    interval = 15
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
    http_options {
      path = "/"
      port = 80
    }
  }
}

# Network Load balancer
resource "yandex_lb_network_load_balancer" "nlb" {
  name = "nlb"
  listener {
    name = "nlb-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_compute_instance_group.group-nlb.load_balancer.0.target_group_id
    healthcheck {
      name = "http"
      interval = 10
      timeout = 5
      healthy_threshold = 5
      unhealthy_threshold = 2
      http_options {
        path = "/"
        port = 80
      }
    }
  }
}


# NAT instance
resource "yandex_compute_instance" "nat-instance" {
  name = "nat-instance"
  hostname = "nat-instance"
  zone     = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Public instance
resource "yandex_compute_instance" "public-instance" {
  name = "public-instance"
  hostname = "public-instance"
  zone     = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd826honb8s0i1jtt6cg"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Private instance
resource "yandex_compute_instance" "private-instance" {
  name = "private-instance"
  hostname = "private-instance"
  zone     = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd8bkgba66kkf9eenpkb"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Output
output "external_ip_address_public" {
  value = yandex_compute_instance.public-instance.network_interface.0.nat_ip_address
}
output "external_ip_address_nat" {
  value = yandex_compute_instance.nat-instance.network_interface.0.nat_ip_address
}
output "internal_ip_address_private" {
  value = yandex_compute_instance.private-instance.network_interface.0.ip_address
}
output "ipaddress_group-nlb" {
  value = yandex_compute_instance_group.group-nlb.instances[*].network_interface[0].ip_address
}
output "nlb_address" {
  value = yandex_lb_network_load_balancer.nlb.listener.*.external_address_spec[0].*.address
}
output "picture_url" {
  value = "https://${yandex_storage_bucket.listopad-netology.bucket_domain_name}/${yandex_storage_object.netology.key}"
}



