resource "yandex_vpc_network" "k8snet" {
  name = "k8snet"
}

resource "yandex_vpc_subnet" "subnet-a" {
  name = "subnet-a"
  v4_cidr_blocks = ["10.5.1.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8snet.id
}

resource "yandex_vpc_subnet" "subnet-b" {
  name = "subnet-b"
  v4_cidr_blocks = ["10.5.2.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k8snet.id
}

resource "yandex_vpc_subnet" "subnet-d" {
  name = "subnet-d"
  v4_cidr_blocks = ["10.5.3.0/24"]
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.k8snet.id
}


