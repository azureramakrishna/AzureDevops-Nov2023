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