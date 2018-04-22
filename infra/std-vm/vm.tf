resource "azurerm_virtual_machine" "vm" {
  name = "${var.name}"
  location = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.private_nic.id}"]
  vm_size = "${var.vm_size}"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
      publisher = "${var.vm_publisher}"
      offer = "${var.vm_offer}"
      sku = "${var.vm_sku}"
      version = "${var.vm_version}"
  }

  storage_os_disk {
    name = "${var.name}-os"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "${var.disk_type}"
  }

  os_profile {
    computer_name = "${var.name}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_windows_config {
    enable_automatic_upgrades = "true"
    provision_vm_agent = "true"

    winrm {
      protocol = "https"
      certificate_url = "${azurerm_key_vault_certificate.vm-cert.secret_id}"
    }
  }

  os_profile_secrets {
    source_vault_id = "${var.vault_id}"
    vault_certificates {
      certificate_url = "${azurerm_key_vault_certificate.vm-cert.secret_id}"
      certificate_store = "My"
    }
  }

  tags {
    env = "${var.tag-env}"
    remote_user = "${var.username}"
    remote_ip = "${azurerm_public_ip.public_ip.ip_address}"
    remote_connection = "winrm"
    remote_port = "5986"
  }
}
