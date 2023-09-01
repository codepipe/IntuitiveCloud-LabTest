# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"  # Update with your desired Azure region
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.200.0.0/20"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create public and private subnets
resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.200.0.0/24"]
}

resource "azurerm_subnet" "private_subnet_1" {
  name                 = "private-subnet-1"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.200.1.0/24"]
}

resource "azurerm_subnet" "private_subnet_2" {
  name                 = "private-subnet-2"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.200.2.0/24"]
}

# Create a public IP for VMs
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

# Create a network security group for VMs
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create security group rules (e.g., allow SSH)
resource "azurerm_network_security_rule" "example" {
  name                        = "example-allow-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}

# Create a virtual network interface for VMs
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.example.id
  }
}

# Create virtual machines (Linux)
resource "azurerm_virtual_machine" "example" {
  count                 = 2
  name                  = "example-vm-${count.index}"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_DS2_v2"  # Adjust the VM size as needed
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "example-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "example-vm-${count.index}"
    admin_username = "adminuser"  # Change to your desired username
    admin_password = "Password123!"  # Change to your desired password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Create a storage account
resource "azurerm_storage_account" "example" {
  name                     = "examplestorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create a container in the storage account
resource "azurerm_storage_container" "example" {
  name                  = "examplecontainer"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"  # Adjust access type as needed
}

# Output the storage account connection string
output "storage_account_connection_string" {
  value = azurerm_storage_account.example.primary_connection_string
}

