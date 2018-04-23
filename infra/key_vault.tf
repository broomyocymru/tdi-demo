data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "demo-vault" {
  name = "vault2qgaqzvmsrc9wbe0"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demo-rg.name}"
  tenant_id = "${data.azurerm_client_config.current.tenant_id}"
  enabled_for_deployment = true

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.service_principal_object_id}"

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update"
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey"
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "restore",
      "set"
    ]
  }
}
