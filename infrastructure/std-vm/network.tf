resource "azurerm_public_ip" "public_ip" {
  name                         = "public_ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"

  tags {
    env = "${var.tag-env}"
  }
}

resource "azurerm_network_interface" "private_nic" {
    name = "${var.name}-nic0"
    location = "${var.location}"
    resource_group_name = "${var.resource_group_name}"

    ip_configuration {
        name = "${var.name}-pip"
        subnet_id = "${var.subnet_id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.public_ip.id}"
    }

    tags {
      env = "${var.tag-env}"
    }
}
