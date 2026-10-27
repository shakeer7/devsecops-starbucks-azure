# ==============================================================================
# 1. RESOURCE GROUP
# ==============================================================================
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "DevSecOps"
    Project     = "Starbucks"
  }
}

# ==============================================================================
# 2. VIRTUAL NETWORK & SUBNETS
# ==============================================================================
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-starbucks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space

  tags = {
    Environment = "DevSecOps"
    Project     = "Starbucks"
  }
}

# Subnet for AKS Cluster Nodes
resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aks_subnet_cidr
}

# Subnet for Tooling VMs (Jump Server / SonarQube / Trivy)
resource "azurerm_subnet" "tooling" {
  name                 = "snet-tooling"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.tooling_subnet_cidr
}

# ==============================================================================
# 3. NETWORK SECURITY GROUP & RULES
# ==============================================================================
resource "azurerm_network_security_group" "tooling_nsg" {
  name                = "nsg-starbucks-tooling"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SonarQube"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Prometheus"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9090"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Grafana-or-AppDev"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-NodeExporter"
    priority                   = 1007
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9100"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "DevSecOps"
    Project     = "Starbucks"
  }
}

resource "azurerm_subnet_network_security_group_association" "tooling_assoc" {
  subnet_id                 = azurerm_subnet.tooling.id
  network_security_group_id = azurerm_network_security_group.tooling_nsg.id
}

# ==============================================================================
# 4. AZURE CONTAINER REGISTRY (ACR)
# ==============================================================================
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true

  tags = {
    Environment = "DevSecOps"
    Project     = "Starbucks"
  }
}

# ==============================================================================
# 5. AZURE KUBERNETES SERVICE (AKS)
# ==============================================================================
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_cluster_name

  default_node_pool {
    name                = "agentpool"
    node_count          = var.aks_node_count
    vm_size             = var.aks_vm_size
    vnet_subnet_id      = azurerm_subnet.aks.id
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    os_disk_size_gb     = 30

    tags = {
      Environment = "DevSecOps"
      Project     = "Starbucks"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "DevSecOps"
    Project     = "Starbucks"
  }
}

# Grant AKS Kubelet permission to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# ==============================================================================
# 6. SSH KEY GENERATION FOR VIRTUAL MACHINES
# ==============================================================================
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# ==============================================================================
# 7. TOOLING VIRTUAL MACHINES (starbucks-app, sonarqube, trivy)
# ==============================================================================
resource "azurerm_public_ip" "server_pips" {
  for_each            = toset(var.tooling_servers)
  name                = "pip-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "DevSecOps"
    Role        = each.key
  }
}

resource "azurerm_network_interface" "server_nics" {
  for_each            = toset(var.tooling_servers)
  name                = "nic-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tooling.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.server_pips[each.key].id
  }

  tags = {
    Environment = "DevSecOps"
    Role        = each.key
  }
}

resource "azurerm_linux_virtual_machine" "servers" {
  for_each            = toset(var.tooling_servers)
  name                = "vm-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.tooling_vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.server_nics[each.key].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Name        = each.key
    Environment = "DevSecOps"
    Role        = each.key
  }
}
