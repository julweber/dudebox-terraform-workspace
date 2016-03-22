# OpenStack configuration
variable "os_auth_url" {}
variable "os_tenant_name" {}
variable "os_tenant_id" {}
variable "os_username" {}
variable "os_password" {}
variable "os_region" {
  default = "hydranodes"
}
variable "volume_type" {
  default = "EMC-ThinVolume"
}
variable "volume_size" {
  default = 10
}
variable "os_fip_network_name" {
  default = "public"
}
variable "os_fip_network_uuid" {}

variable "avl1_name" {
  default = "de_sky_1"
}
variable "avl2_name" {
  default = "de_sky_2"
}
variable "avl3_name" {
  default = "de_sky_3"
}
variable "dns1" {
  default = "8.8.8.8"
}
variable "dns2" {
  default = "8.8.4.4"
}
variable "flavor_name" {
  default = "m1.medium"
}
variable "image_name" {
  default = "Ubuntu-trusty-Daily-x64"
}

# Jumphost machine configuration
variable "public_key_main" {
  default = "~/.ssh/id_rsa.pub"
}
variable "private_key_main" {
  default = "~/.ssh/id_rsa"
}
variable "user_name" {
  default = "ubuntu"
}
