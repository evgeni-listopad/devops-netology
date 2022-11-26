resource "yandex_compute_instance" "node" {
  for_each                  = local.instance_name
  name                      = each.key
  zone                      = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = var.centos
      type        = "network-nvme"
      size        = "50"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = each.value
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }

}

locals {
  instance_name = {
    clickhouse = "192.168.101.10",
    vector = "192.168.101.11",
    lighthouse = "192.168.101.12"
    }
}

variable "centos" {
  default = "fd8j0db3lnmi4g7k93u5"
}

resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}
