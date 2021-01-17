variable "azure_environment" {
    type        = string
    description = "The target Azure cloud environment for the cluster. Possible values are public, usgovernment, german, and china."
    default     = "public"
}

variable "azure_subscription_id" {
    type        = string
    description = "The Subscription ID that should be used to interact with Azure API"
}

variable "azure_client_id" {
    type        = string
    description = "The app ID that should be used to interact with Azure API"
}

variable "azure_client_secret" {
    type        = string
    description = "The password that should be used to interact with Azure API"
}

variable "azure_tenant_id" {
    type        = string
    description = "The tenant ID that should be used to interact with Azure API"
}

variable "azure_region" {
    type        = string
    description = "The target Azure region for the cluster."
}

variable "resource_group" {
    default = "mycpd-rg"
}

variable "cluster_name" {
    type = string
    default = "myaro-cluster"
}

### Network Config
variable "preexisting_network" {
    type = bool
    default = false
}

variable "existing_vnet_resource_group" {
    default = "vnet-rg"
    type = string
    description = "If new_or_existing is set to existing, provide the Resource Group name for the Vnet"
}

variable "virtual_network_name" {
    default = "ocpfourx-vnet"
    type = string
    description = "Name of the virtual network. If not existing, will create one"
}

variable "virtual_network_cidr" {
    default = "10.0.0.0/16"
    type = string
    description = "Virtual Network CIDR"
}

variable "master_subnet_name" {
    default = "master"
    type = string
    description = "Name for master subnet. Subnet to deploy master nodes"
}

variable "master_subnet_cidr" {
    default = "10.0.1.0/24"
    type = string
    description = "Master Subnet CIDR"
}

variable "worker_subnet_name" {
    default = "worker"
    type = string
    description = "Name for worker subnet. Subnet to deploy worker nodes"
}

variable "worker_subnet_cidr" {
    default = "10.0.2.0/24"
    type = string
    description = "Worker Subnet CIDR"
}

variable "dns_zone_name" {
    type = string
    description = "Domain/subdomain to be used"
}

variable "master_vm_size" {
    type = string
    default = "Standard_D8s_v3"
    description = "VM size of the master nodes"
}

variable "worker_vm_size" {
    type = string
    default = "Standard_D16s_v3"
    description = "VM size of the worker nodes"
}

variable "worker_vm_disk_size" {
    type = number
    default = 256
    description = "Disk size of worker nodes"
}

variable "worker_vm_count" {
    type = number
    default = 3
    description = "Number of worker nodes"
}

variable "ingress_visibility" {
    type = string
    description = "Ingress endpoints resolve to private or public IP"

    validation {
      condition = var.ingress_visibility == "Private" || var.ingress_visibility == "Public"
      error_message = "The ingress_visibilty variable has to be 'Private' or 'Public' (note the upper case P)."
    }
}

variable "api_server_visibility" {
    type = string
    description = "API server resolve to private or public IP"

    validation {
      condition = var.api_server_visibility == "Private" || var.api_server_visibility == "Public"
      error_message = "The api_server_visibility variable has to be 'Private' or 'Public' (note the upper case P)."
    }
}

variable "pull_secret_file_path" {
    type = string
    description = "File path to the pull secret"
}