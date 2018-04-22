data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "demo-vault" {
  name = "demo-vault"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demo-rg.name}"
  tenant_id = "${data.azurerm_client_config.current.tenant_id}"

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.service_principal_object_id}"

    certificate_permissions = [
      "all",
    ]

    key_permissions = [
      "all",
    ]

    secret_permissions = [
      "all",
    ]
  }
}
