resource "yandex_compute_instance" "nod1" {
  name        = "nod1"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"
  
  resources {
    core_fraction = 100
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83m7rp3r4l12c2keph"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
    ip_address = "10.5.1.240"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}

resource "yandex_compute_instance" "nod2" {
  name        = "nod2"
  platform_id = "standard-v2"
  zone        = "ru-central1-b"
  
  resources {
    core_fraction = 100
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83m7rp3r4l12c2keph"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-b.id
    nat       = true
    ip_address = "10.5.2.240"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}

resource "yandex_compute_instance" "nod3" {
  name        = "nod3"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"
  
  resources {
    core_fraction = 100
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83m7rp3r4l12c2keph"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-d.id
    ip_address = "10.5.3.240"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}