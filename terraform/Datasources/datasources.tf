# Use the exisiting resource group
data "azurerm_resource_group" "example" {
  name = "tf-datasources-rg"
}

# Use this data source to access information about an existing Virtual Network.
data "azurerm_virtual_network" "example" {
  name                = "tf-vnet-01"
  resource_group_name = "tf-datasources-rg"
}

# Use this data source to access information about an existing Subnet within a Virtual Network.
data "azurerm_subnet" "example" {
  name                 = "tf-subnet"
  virtual_network_name = "tf-vnet-01"
  resource_group_name  = "tf-datasources-rg"
}

# Use this data source to access information about an existing Key Vault.
data "azurerm_key_vault" "example" {
  name                = "tfkv123"
  resource_group_name = "tf-datasources-rg"
}

#Use this data source to access information about an existing Key Vault Secret.
data "azurerm_key_vault_secret" "example1" {
  name         = "tfadminuser"
  key_vault_id = data.azurerm_key_vault.example.id
}

#Use this data source to access information about an existing Key Vault Secret.
data "azurerm_key_vault_secret" "example2" {
  name         = "tfadminpassword"
  key_vault_id = data.azurerm_key_vault.example.id
}
