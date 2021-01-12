variable "resource_group" {
    type = string
    description = "Resource group for the deployment"
}

variable "region" {
    type = string
    description = "Azure Region to deploy resources to. NOTE: If using an existing network, you must provide the network region here."
}

variable "azure_client_id" {
    type        = string
    description = "The app ID that should be used to interact with Azure API"
}

variable "cluster_name" {
    type = string
    description = "Name of the cluster. Also used as a prefix for all the resources created"
}

variable "api_server_visibility" {
    type = string
    description = "API server resolve to private or public IP"
}

variable "ingress_visibility" {
    type = string
    description = "Ingress endpoints resolve to private or public IP"
}

variable "virtual_network_cidr" {
    type = string
    description = "Virtual Network CIDR"
}

variable "master_subnet_id" {
    type = string
    description = "Subnet to deploy master nodes"
}

variable "worker_subnet_id" {
    type = string
    description = "Subnet to deploy worker nodes"
}

variable "dns_zone_name" {
    type = string
    description = "Domain/subdomain to be used"
}

variable "master_vm_size" {
    type = string
    description = "VM size of the master nodes"
}

variable "worker_vm_size" {
    type = string
    description = "VM size of the worker nodes"
}

variable "worker_vm_disk_size" {
    type = number
    description = "Disk size of worker nodes"
}

variable "worker_vm_count" {
    type = number
    description = "Number of worker nodes"
}
