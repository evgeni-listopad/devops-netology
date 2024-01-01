# Variables
variable "yc_token" {
  default = "****************U8e5DXTWT6IdDA"
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

# SA
resource "yandex_iam_service_account" "sa-diploma" {
  folder_id = var.yc_folder_id
  name        = "sa-diploma"
}
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-diploma.id}"
}

# Bucket-key
resource "yandex_iam_service_account_static_access_key" "accesskey-bucket" {
  service_account_id = yandex_iam_service_account.sa-diploma.id
}

# Bucket-create
resource "yandex_storage_bucket" "listopad-diploma" {
  access_key = yandex_iam_service_account_static_access_key.accesskey-bucket.access_key
  secret_key = yandex_iam_service_account_static_access_key.accesskey-bucket.secret_key
  bucket     = "listopad-diploma"
  default_storage_class = "STANDARD"
  acl           = "public-read"
  force_destroy = "true"
  anonymous_access_flags {
    read = true
    list = true
    config_read = true
  }
}

# VPC
resource "yandex_vpc_network" "network-diploma" {
  name = "network-diploma"
  folder_id = var.yc_folder_id
}

# Subnets
resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-diploma.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-diploma.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "subnet-c" {
  name           = "subnet-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network-diploma.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

# Virtual machines
## Kubernetes master
resource "yandex_compute_instance" "vm-master" {
  name = "vm-master"
  hostname = "vm-master"
  zone      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd84nt41ssoaapgql97p"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

## Kubernetes worker-1
resource "yandex_compute_instance" "vm-worker-1" {
  name = "vm-worker-1"
  hostname = "vm-worker-1"
  zone      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd84nt41ssoaapgql97p"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

## Kubernetes worker-2
resource "yandex_compute_instance" "vm-worker-2" {
  name = "vm-worker-2"
  hostname = "vm-worker-2"
  zone      = "ru-central1-b"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd84nt41ssoaapgql97p"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-b.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

## Kubernetes worker-3
resource "yandex_compute_instance" "vm-worker-3" {
  name = "vm-worker-3"
  hostname = "vm-worker-3"
  zone      = "ru-central1-c"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd84nt41ssoaapgql97p"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-c.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

## Ansible inventory for preparation
resource "local_file" "inventory-preparation" {
  content = <<EOF1
[kube-cloud]
${yandex_compute_instance.vm-master.network_interface.0.nat_ip_address}
${yandex_compute_instance.vm-worker-1.network_interface.0.nat_ip_address}
${yandex_compute_instance.vm-worker-2.network_interface.0.nat_ip_address}
${yandex_compute_instance.vm-worker-3.network_interface.0.nat_ip_address}  
  EOF1
  filename = "./ansible/inventory-preparation"
  depends_on = [yandex_compute_instance.vm-master, yandex_compute_instance.vm-worker-1, yandex_compute_instance.vm-worker-2, yandex_compute_instance.vm-worker-3]
}

## Ansible inventory for Kuberspray
resource "local_file" "inventory-kubespray" {
  content = <<EOF2
all:
  hosts:
    ${yandex_compute_instance.vm-master.fqdn}:
      ansible_host: ${yandex_compute_instance.vm-master.network_interface.0.ip_address}
      ip: ${yandex_compute_instance.vm-master.network_interface.0.ip_address}
      access_ip: ${yandex_compute_instance.vm-master.network_interface.0.ip_address}
    ${yandex_compute_instance.vm-worker-1.fqdn}:
      ansible_host: ${yandex_compute_instance.vm-worker-1.network_interface.0.ip_address}
      ip: ${yandex_compute_instance.vm-worker-1.network_interface.0.ip_address}
      access_ip: ${yandex_compute_instance.vm-worker-1.network_interface.0.ip_address}
    ${yandex_compute_instance.vm-worker-2.fqdn}:
      ansible_host: ${yandex_compute_instance.vm-worker-2.network_interface.0.ip_address}
      ip: ${yandex_compute_instance.vm-worker-2.network_interface.0.ip_address}
      access_ip: ${yandex_compute_instance.vm-worker-2.network_interface.0.ip_address}
    ${yandex_compute_instance.vm-worker-3.fqdn}:
      ansible_host: ${yandex_compute_instance.vm-worker-3.network_interface.0.ip_address}
      ip: ${yandex_compute_instance.vm-worker-3.network_interface.0.ip_address}
      access_ip: ${yandex_compute_instance.vm-worker-3.network_interface.0.ip_address}
  children:
    kube_control_plane:
      hosts:
        ${yandex_compute_instance.vm-master.fqdn}:
    kube_node:
      hosts:
        ${yandex_compute_instance.vm-worker-1.fqdn}:
        ${yandex_compute_instance.vm-worker-2.fqdn}:
        ${yandex_compute_instance.vm-worker-3.fqdn}:
    etcd:
      hosts:
        ${yandex_compute_instance.vm-master.fqdn}:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
  EOF2
  filename = "./ansible/inventory-kubespray"
  depends_on = [yandex_compute_instance.vm-master, yandex_compute_instance.vm-worker-1, yandex_compute_instance.vm-worker-2, yandex_compute_instance.vm-worker-3]
}
