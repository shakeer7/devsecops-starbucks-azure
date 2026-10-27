variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-starbucks-devsecops"
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "eastus"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_cidr" {
  description = "Subnet CIDR for Azure Kubernetes Service (AKS)"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tooling_subnet_cidr" {
  description = "Subnet CIDR for DevSecOps Tooling VMs (Jump Server, SonarQube, Trivy)"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "acr_name" {
  description = "Globally unique name for Azure Container Registry (alphanumeric only)"
  type        = string
  default     = "acrstarbucksdevsecops"
}

variable "aks_cluster_name" {
  description = "Name of the Azure Kubernetes Service cluster"
  type        = string
  default     = "aks-starbucks"
}

variable "aks_node_count" {
  description = "Default number of nodes in AKS default node pool"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for AKS worker nodes"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "tooling_vm_size" {
  description = "VM size for the DevSecOps tooling servers"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "admin_username" {
  description = "Administrator username for Linux VMs"
  type        = string
  default     = "azureuser"
}

variable "tooling_servers" {
  description = "Names of the tooling servers to provision"
  type        = list(string)
  default = [
    "starbucks-app",
    "sonarqube",
    "trivy"
  ]
}
