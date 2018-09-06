variable "server_image" {
  default = "Ubuntu 18.04 Bionic Beaver - Latest"
}

variable "ssh_key" {
  default = "your_ssh_key_name"
}

variable "provider_network_id" {
  default = "54258498-a513-47da-9369-1a644e4be692"
}

variable "provider_network_name" {
  default = "provider"
}

variable "ipv6_subnetpool_name" {
  default = "customer_ipv6"
}

variable "ipv6_subnetpool_id" {
  default = "f541f3b6-af22-435a-9cbb-b233d12e74f4"
}
