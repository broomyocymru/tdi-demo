variable "azurerm_subscription_id" {}
variable "azurerm_client_id" {}
variable "azurerm_client_secret" {}
variable "azurerm_tenant_id" {}

variable "location" { default = "UK West"}
variable "tag-env" { default = "dev"}

variable "vnet-range" { default = "10.0.0.0/20"}
variable "app-subnet-range" { default = "10.0.0.0/24"}
