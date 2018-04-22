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

  security_rule {
    name                       = "rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "www"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "winrm"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985-5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    env = "${var.tag-env}"
  }
}
