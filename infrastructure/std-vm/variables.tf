variable "name" {}
variable "location" {}
variable "tag-env" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "username" {}
variable "password" {}
variable "disk_type" { default = "Standard_LRS"}
variable "vm_size" { default = "Standard_D2_v2"}
variable "vm_version" { default = "latest"}
variable "vm_offer" {default = "WindowsServer"}
variable "vm_sku" {default = "2016-Datacenter"}
variable "vm_publisher" {default = "MicrosoftWindowsServer"}
