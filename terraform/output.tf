output "internal_ip_address_service01_yandex_cloud" {
  value = "${yandex_compute_instance.service01.network_interface.0.ip_address}"
}

output "external_ip_address_service01_yandex_cloud" {
  value = "${yandex_compute_instance.service01.network_interface.0.nat_ip_address}"
}
