provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  environment     = var.azure_environment
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