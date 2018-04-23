# resource group
resource "azurerm_resource_group" "demo-rg" {
  name = "demo-rg"
  location = "${var.location}"

  tags {
    env = "${var.tag-env}"
  }
}
