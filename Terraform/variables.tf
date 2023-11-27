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