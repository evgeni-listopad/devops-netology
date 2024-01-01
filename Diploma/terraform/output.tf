output "internal-ip-address-vm-master" {
  value = "${yandex_compute_instance.vm-master.network_interface.0.ip_address}"
}
output "fqdn-vm-master" {
  value = "${yandex_compute_instance.vm-master.fqdn}"
}
