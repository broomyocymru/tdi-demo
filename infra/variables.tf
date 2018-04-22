variable "azurerm_subscription_id" {}
variable "azurerm_client_id" {}
variable "azurerm_client_secret" {}
variable "azurerm_tenant_id" {}

variable "location" { default = "UK West"}
variable "tag-env" { default = "dev"}

variable "vnet-range" { default = "11.0.0.0/20"}
variable "app-subnet-range" { default = "11.0.0.0/24"}


variable "vm1-username" { default = "demo-admin"}
variable "vm1-password" { default = "D3moAdm!n"}
