output "dc01_public_ip" {
  value       = azurerm_public_ip.dc01.ip_address
  description = "DC01 public IP — for RDP."
}

output "dc01_private_ip" {
  value       = azurerm_network_interface.dc01.private_ip_address
  description = "Always 10.0.1.4 — DC01's fixed address other VMs use for DNS."
}

output "fs01_public_ip" {
  value       = azurerm_public_ip.fs01.ip_address
  description = "FS01 public IP — for RDP."
}

output "client01_public_ip" {
  value       = azurerm_public_ip.client01.ip_address
  description = "CLIENT01 public IP — this is the one you'll RDP into to test as different users."
}

output "key_vault_name" {
  value       = azurerm_key_vault.lab_kv.name
  description = "Pass this to configure-lab.ps1 later, to pull the password."
}