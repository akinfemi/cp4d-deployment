provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  environment     = var.azure_environment
}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

resource "azurerm_resource_group" "cpdrg" {
  name = var.resource_group
  location = var.azure_region
}

module "vnet" {
  source = "./vnet"
  resource_group = azurerm_resource_group.cpdrg.name
  preexisting_network = var.preexisting_network
  existing_vnet_rg = var.existing_vnet_resource_group
  virtual_network_name = var.virtual_network_name
  network_cidr = var.virtual_network_cidr
  region = var.azure_region
  master_subnet_name = var.master_subnet_name
  master_subnet_cidr = var.master_subnet_cidr
  worker_subnet_name = var.worker_subnet_name
  worker_subnet_cidr = var.worker_subnet_cidr
}

module "aro" {
  source = "./aro"
  resource_group = azurerm_resource_group.cpdrg.name
  region = var.azure_region
  azure_client_id = var.azure_client_id
  azure_client_secret = var.azure_client_secret
  cluster_name = var.cluster_name
  api_server_visibility = var.api_server_visibility
  ingress_visibility = var.ingress_visibility
  # virtual_network_rg = var.preexisting_network ? var.existing_vnet_resource_group : azurerm_resource_group.cpdrg.name
  # virtual_network_name = module.vnet.virtual_network_name
  virtual_network_cidr = module.vnet.network_cidr
  master_subnet_id = module.vnet.master_subnet_id
  worker_subnet_id = module.vnet.worker_subnet_id
  dns_zone_name = var.dns_zone_name
  master_vm_size = var.master_vm_size
  worker_vm_size = var.worker_vm_size
  worker_vm_count = var.worker_vm_count
  worker_vm_disk_size = var.worker_vm_disk_size
  resource_group_id = azurerm_resource_group.cpdrg.id
  virtual_network_id = module.vnet.virtual_network_id
  client_object_id = data.azurerm_client_config.current.object_id
  pull_secret_file_path = var.pull_secret_file_path
  subscription_id = data.azurerm_subscription.current.id
}