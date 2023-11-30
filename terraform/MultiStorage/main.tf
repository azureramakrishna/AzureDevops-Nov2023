# Azure terraform provider version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = false
    }
  }

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Azure terraform backend
terraform {
  backend "azurerm" {
    resource_group_name  = "cloud-shell-rg"
    storage_account_name = "saanvikitcloudshell"
    container_name       = "tfstate"
    key                  = "multistorage.terraform.tfstate"
  }
}

# Terraform locals

locals {
  project       = "saanvikit"
  location      = "westus"
  adminUser     = "azureuser"
  adminPassword = "P@$$word@12345"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "${local.project}-resourcegroup"
  location = local.location
}

# Create a storage account 
resource "azurerm_storage_account" "example" {
  name                     = "${lower(local.project)}storage${count.index + 1}"
  count                    = 20
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Create a virtual network 
resource "azurerm_virtual_network" "example" {
  name                = "${local.project}-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["172.16.1.0/25"]
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "${local.project}-snet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["172.16.1.0/25"]
}

# Create a NSG
resource "azurerm_network_security_group" "example" {
  name                = "${local.project}-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create a publicip
resource "azurerm_public_ip" "example" {
  name                = "${local.project}-pip-${count.index}"
  count               = 5
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

# Create a NIC
resource "azurerm_network_interface" "example" {
  depends_on          = [azurerm_public_ip.example]
  name                = "${local.project}-nic-${count.index}"
  count               = 5
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    public_ip_address_id          = azurerm_public_ip.example[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associate NSG to Subnet 
resource "azurerm_subnet_network_security_group_association" "example" {
  depends_on                = [azurerm_subnet.example, azurerm_network_security_group.example]
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Create a windows VM
resource "azurerm_windows_virtual_machine" "example" {
  depends_on          = [azurerm_network_interface.example]
  name                = "${local.project}-vm-${count.index}"
  count               = 5
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "standard_ds1_v2"
  computer_name       = "${local.project}-vm-${count.index}"
  admin_username      = local.adminUser
  admin_password      = local.adminPassword
  network_interface_ids = [
    "${azurerm_network_interface.example[count.index].id}",
  ]

  os_disk {
    name                 = "${local.project}-vm-osdisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "example" {
  depends_on           = [azurerm_windows_virtual_machine.example]
  name                 = "${local.project}-vm-disk-${count.index}"
  count                = 5
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.example[count.index].id
  lun                = count.index
  count              = 5
  caching            = "ReadWrite"
}