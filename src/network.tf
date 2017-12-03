resource "azurerm_virtual_network" "vnet" {
  name = "demo-vnet"
  address_space = ["${var.vnet-range}"]
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demo-rg.name}"

  tags {
    env = "${var.tag-env}"
  }
}


resource "azurerm_subnet" "app-subnet" {
  name = "apps"
  resource_group_name = "${azurerm_resource_group.demo-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix = "${var.app-subnet-range}"
  network_security_group_id = "${azurerm_network_security_group.app-nsg.id}"
}


resource "azurerm_network_security_group" "app-nsg" {
  name = "app-nsg"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demo-rg.name}"

  tags {
    env = "${var.tag-env}"
  }
}
