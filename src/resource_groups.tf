# resource group
resource "azurerm_resource_group" "demo-rg" {
  name = "demo-rg"
  location = "${var.location}"

  tags {
    env = "${var.tag-env}"
  }
}

/*
resource "azurerm_resource_group" "euro-rg" {
  name = "euro-rg"
  location = "North Europe"

  tags {
    env = "${var.tag-env}"
  }
}
*/
