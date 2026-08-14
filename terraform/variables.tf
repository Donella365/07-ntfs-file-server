variable "location" {
  type        = string
  default     = "mexicocentral"
  description = "Azure region. Locked to an allowed region for this Student subscription."
}

variable "resource_group_name" {
  type        = string
  default     = "RG-FileServerLab"
  description = "Must stay consistent — the RBAC lab reads this group by name."
}

variable "vnet_name" {
  type    = string
  default = "VNET-FileServerLab"
}

variable "subnet_name" {
  type    = string
  default = "Subnet-Servers"
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "nsg_name" {
  type    = string
  default = "NSG-RDP"
}

variable "rdp_source" {
  type        = string
  description = "Your public IP in CIDR format, e.g. 73.129.192.100/32. Get it from ifconfig.me."
}

variable "admin_username" {
  type    = string
  default = "azureadmin"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Set as TF_VAR_admin_password environment variable — never write this in a file."
}

variable "server_vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "client_vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}