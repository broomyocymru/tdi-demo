module "vm1" {
  source = "./std-vm"
  name = "vm-1"
  resource_group_name = "${azurerm_resource_group.demo-rg.name}"
  location = "${var.location}"
  tag-env = "${var.tag-env}"
  subnet_id = "${azurerm_subnet.app-subnet.id}"
  username = "${var.vm1-username}"
  password = "${var.vm1-password}"
}
