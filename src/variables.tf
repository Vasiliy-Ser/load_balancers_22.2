###cloud vars
#variable "token" {
#  type        = string
#  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
#}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr_pub" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "default_cidr_priv" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "vpc"
  description = "VPC name"
}

variable "public_name" {
  type        = string
  default     = "public"
  description = "subnet name"
}

variable "private_name" {
  type        = string
  default     = "private"
  description = "subnet name"
}

variable "lamp-group" {
  type        = string
  default     = "lamp"
  description = "subnet name"
}

variable "account_id" {
  type        = string
  default     = "aje79ac17shus900rr5t"
  description = "Identity and Access Management"
}


variable "platform_id_name" {
  type        = string
  default     = "standard-v1"
  description = "platform id name"
}

variable "sg_nat_name" {
  type        = string
  default     = "sg_nat_name"
  description = "sg nat name"
}

variable "nat-instance-route" {
  type        = string
  default     = "nat-instance-route"
  description = "nat instance route name"
}

variable "nat_gateway" {
  type        = string
  default     = "nat-gateway"
  description = "nat-gateway name"
}

variable "vm_web_params" {
  type = object({
    count         = number
    vm_name       = string
    zone          = string
    cpu           = number
    ram           = number
    core_fraction = number
    disk_size     = number
    preemptible   = string
    image_id      = string
  })
  default = {
    count         = 1
    vm_name       = "priv_vm"
    zone          = "ru-central1-a"
    cpu           = 2
    ram           = 2
    core_fraction = 20
    disk_size     = 10
    preemptible   = "true"
    image_id      = "fd80mrhj8fl2oe87o4e1"
    }
  description = "Parameters of VM web (count)"
}

variable "vm_params" {
  type = object({
    count         = number
    vm_name       = string
    zone          = string
    cpu           = number
    ram           = number
    core_fraction = number
    disk_size     = number
    preemptible   = string
    nat           = string
    image_id      = string
  })
  default = {
    count         = 3
    vm_name       = "pub_vm"
    zone          = "ru-central1-a"
    cpu           = 2
    ram           = 2
    core_fraction = 20
    disk_size     = 10
    preemptible   = "true"
    nat           = "true"
    image_id      = "fd827b91d99psvq5fjit"
  }
  description = "Parameters of VM (count)"
}

variable "disk_params" {
  type = object({
    count       = number
    name_prefix = string
    type        = string
    zone        = string
    size        = number
  })
  default = {
    count       = 3
    name_prefix = "storage-disk"
    type        = "network-hdd"
    zone        = "ru-central1-a"
    size        = 1 
  }
}

variable "vms_ssh_root_key" {
  type        = list(string)
  default     = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhtxtFIozHeOb0eySiG2+bVeA2sWrLkwJxRyrxgpA1H vm30@vm30"
  ]
  description = "ssh-keygen -t ed25519"
}