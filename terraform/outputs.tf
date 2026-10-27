output "resource_group_name" {
  description = "The name of the provisioned Azure Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "The Azure region used"
  value       = azurerm_resource_group.rg.location
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  description = "Name of the Azure Kubernetes Service cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_kubeconfig_command" {
  description = "Azure CLI command to configure kubectl credentials for the AKS cluster"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks.name} --overwrite-existing"
}

output "server_public_ips" {
  description = "Public IP addresses for each tooling VM"
  value = {
    for name, pip in azurerm_public_ip.server_pips :
    name => pip.ip_address
  }
}

output "ssh_private_key_pem" {
  description = "Private SSH key to log into the tooling VMs (save to jumpserver.pem)"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "ssh_connect_commands" {
  description = "Commands to SSH into the tooling VMs"
  value = {
    for name, pip in azurerm_public_ip.server_pips :
    name => "ssh -i jumpserver.pem ${var.admin_username}@${pip.ip_address}"
  }
}
