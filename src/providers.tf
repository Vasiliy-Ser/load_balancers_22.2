terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.5"
}

provider "yandex" {
  # token     = var.token
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  shared_credentials_file  = "/home/vm30/.aws/credentials"
  service_account_key_file = file("~/.authorized_key.json")
}

resource "yandex_storage_bucket" "my-bucket-dog" {
  bucket = "my-bucket-dog"
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.my-bucket-dog.bucket
  key    = "image.jpg"
  source = "/home/vm30/homework/22.2/terraform_2/image/image.jpg"
  acl = "public-read"
  tags = {
    test = "value"
  }
}
