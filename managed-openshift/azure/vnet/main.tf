data "azurerm_subnet" "preexisting_master_subnet" {
    count = var.preexisting_network ? 1 : 0
    resource_group_name  = var.existing_vnet_rg
    virtual_network_name = var.virtual_network_name
    name                 = var.master_subnet_name
}

data "azurerm_subnet" "preexisting_worker_subnet" {
    count = var.preexisting_network ? 1 : 0
    resource_group_name  = var.existing_vnet_rg
    virtual_network_name = var.virtual_network_name
    name                 = var.worker_subnet_name
}

data "azurerm_virtual_network" "preexisting_virtual_network" {
    count = var.preexisting_network ? 1 : 0
    resource_group_name = var.existing_vnet_rg
    name                = var.virtual_network_name
}

locals {
    master_subnet_id    = var.preexisting_network ? data.azurerm_subnet.preexisting_master_subnet[0].id : azurerm_subnet.master[0].id
    worker_subnet_id    = var.preexisting_network ? data.azurerm_subnet.preexisting_worker_subnet[0].id : azurerm_subnet.worker[0].id
    virtual_network     = var.preexisting_network ? data.azurerm_virtual_network.preexisting_virtual_network[0].name : azurerm_virtual_network.cluster_vnet[0].name
    virtual_network_id  = var.preexisting_network ? data.azurerm_virtual_network.preexisting_virtual_network[0].id : azurerm_virtual_network.cluster_vnet[0].id
}

resource "azurerm_virtual_network" "cluster_vnet" {
    count = var.preexisting_network ? 0 : 1
    name                = var.virtual_network_name
    address_space       = [var.network_cidr]
    location            = var.region
    resource_group_name = var.resource_group
}

resource "azurerm_subnet" "master" {
    count = var.preexisting_network ? 0 : 1
    name                 = var.master_subnet_name
    resource_group_name  = var.resource_group
    virtual_network_name = azurerm_virtual_network.cluster_vnet[0].name
    address_prefixes     = [var.master_subnet_cidr]
    
    enforce_private_link_service_network_policies = true
    service_endpoints = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

resource "azurerm_subnet" "worker" {
    count = var.preexisting_network ? 0 : 1
    name                 = var.worker_subnet_name
    resource_group_name  = var.resource_group
    virtual_network_name = azurerm_virtual_network.cluster_vnet[0].name
    address_prefixes     = [var.worker_subnet_cidr]

    service_endpoints = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}