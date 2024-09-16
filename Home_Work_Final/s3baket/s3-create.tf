resource "yandex_iam_service_account_static_access_key" "sc-netology-static-key" {
  service_account_id = data.yandex_iam_service_account.sc-netology.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "terrafrom-state" {
  access_key = yandex_iam_service_account_static_access_key.sc-netology-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sc-netology-static-key.secret_key
  bucket     = "terraform-sate"
}

output "access_key_sa_storage_admin_for_terrafrom-state-bucket" {
  description = "access_key sc-netology for terrafrom-state"
  value       = yandex_storage_bucket.terrafrom-state.access_key
  sensitive   = true
}

output "secret_key_sa_storage_admin_for_terrafrom-state-bucket" {
  description = "secret_key sc-netology for terrafrom-state"
  value       = yandex_storage_bucket.terrafrom-state.secret_key
  sensitive   = true
}

data "yandex_iam_service_account" "sc-netology" {
  folder_id = "b1g2np7f861hs7r12rdr"
  name      = "sc-netology"
}