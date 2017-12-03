resource "azurerm_virtual_machine" "win-vm" {
  name = "${var.name}"
  location = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.private_nic.id}"]
}
