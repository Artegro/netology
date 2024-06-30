# Network
resource "yandex_vpc_network" "network" {
  name = "netology"
}
resource "yandex_vpc_subnet" "nw1" {
  name           = "nw1"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  description    = "NAT instance"
  network_id     = yandex_vpc_network.network.id
}
 resource "yandex_vpc_subnet" "nw2" {
  name           = "nw2"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-b"
  description    = "Private instance"
  network_id     = yandex_vpc_network.network.id
}
 resource "yandex_vpc_subnet" "nw3" {
  name           = "nw3"
  v4_cidr_blocks = ["192.168.30.0/24"]
  zone           = "ru-central1-b"
  description    = "Private instance"
  network_id     = yandex_vpc_network.network.id
}
#Nods
resource "yandex_compute_instance" "vm1" {
  name        = "vm1"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
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
    subnet_id = yandex_vpc_subnet.nw1.id
    nat       = true
    ip_address = "192.168.10.254"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}

resource "yandex_compute_instance" "vm2" {
  name        = "vm2"
  platform_id = "standard-v1"
  zone        = "ru-central1-b"
  
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
    subnet_id = yandex_vpc_subnet.nw2.id
  }

  metadata = {
     ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
 }
resource "yandex_compute_instance" "vm3" {
  name        = "vm3"
  platform_id = "standard-v1"
  zone        = "ru-central1-d"
  
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
    subnet_id = yandex_vpc_subnet.nw3.id
  }

  metadata = {
     ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
 }
