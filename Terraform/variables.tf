variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "terraform-resource-group"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
  default     = "west europe"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
  default     = "saanvikitterraform2023"
}

variable "tags" {
  default = {
    environment = "DEV"
    department  = "Cloud"
  }
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
  default     = "terraform-vnet"
}

variable "virtual_network_address" {
  type    = list(any)
  default = ["192.168.0.0/24", "172.16.0.0/28"]
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
  default     = "terraform-snet"
}

variable "subnet_address" {
  type    = list(any)
  default = ["192.168.0.0/25"]
}

variable "network_security_group_name" {
  type    = string
  default = "terraform-nsg"
}

variable "publicip_name" {
  type    = string
  default = "terraform-pip"
}

variable "network_interface_name" {
  type    = string
  default = "terraform-nic"
}

variable "virtual_machine_name" {
  type    = string
  default = "terraform-vm"
}

variable "virtual_machine_size" {
  type    = string
  default = "Standard_Ds2_v3"
}

variable "adminuser" {
  type    = string
  default = "azureuser"
}

variable "adminPassword" {
  type    = string
  default = "Azuredevops@12345"
}