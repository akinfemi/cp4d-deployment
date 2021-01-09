variable "resource_group" {
    type = string
    description = "Resource group for the deployment"
}

variable "preexisting_network" {
    type = bool
    default = false
}

variable "existing_vnet_rg" {
    type = string
    description = "If new_or_existing is set to existing, provide the Resource Group name for the Vnet"
}

variable "virtual_network_name" {
    type = string
    description = "Name of the virtual network. If not existing, will create one"
}

variable "network_cidr" {
    type = string
    description = "Virtual Network CIDR"
}

variable "region" {
    type = string
    description = "Azure Region to deploy resources to. NOTE: If using an existing network, you must provide the network region here."
}

variable "master_subnet_name" {
    type = string
    description = "Name for master subnet. Subnet to deploy master nodes"
}

variable "master_subnet_cidr" {
    type = string
    description = "Master Subnet CIDR"
}

variable "worker_subnet_name" {
    type = string
    description = "Name for worker subnet. Subnet to deploy worker nodes"
}

variable "worker_subnet_cidr" {
    type = string
    description = "Worker Subnet CIDR"
}