variable "resource_group_name" {
  type        = string
  description = "Name of the storage account"
  default     = "for-each-group"
}

variable "location" {
  type        = string
  description = "Name of the storage account"
  default     = "eastus"
}

variable "storageaccountname" {
  type        = set(string)
  description = "Name of the storage account"
  default     = ["ramakrishnasa2023", "shanmukhisa2023", "vamshisa2023"]
}




