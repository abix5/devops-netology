resource "yandex_compute_instance" "service01" {
  name                      = "service01"
  zone                      = "ru-central1-a"
  hostname                  = "service01.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "${var.debian-service}"
      name     = "root-service01"
      type     = "network-nvme"
      size     = "20"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
