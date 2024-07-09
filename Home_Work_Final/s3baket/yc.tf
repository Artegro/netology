terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.15"
}
provider "yandex" {
  zone      = "ru-central1-a"
  token     = "t1."
  cloud_id  = ""
  folder_id = ""
}