variable "resource_group" {
    type = string
    description = "Resource group for the deployment"
}

variable "resource_group_id" {
    type = string
    description = "Resource Group ID"
}

variable "region" {
    type = string
    description = "Azure Region to deploy resources to. NOTE: If using an existing network, you must provide the network region here."
}

variable "azure_client_id" {
    type        = string
    description = "The app ID that should be used to interact with Azure API"
}

variable "azure_client_secret" {
    type        = string
    description = "The password that should be used to interact with Azure API"
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

variable "virtual_network_name" {
    type = string
    description = "Virtual Network Name"
}

variable "virtual_network_id" {
    type = string
    description = "Virtual Network ID"
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

variable "roles" {
  description = "Roles to be assigned to the Principal"
  type        = list(object({ role = string }))
  default = [
    {
      role = "Contributor"
    },
    {
      role = "User Access Administrator"
    }
  ]
}

variable "client_object_id" {
  type = string
  description = "Client Object ID"
}

#az ad sp list --filter "displayname eq 'Azure Red Hat OpenShift RP'" --query "[?appDisplayName=='Azure Red Hat OpenShift RP'].{name: appDisplayName, objectId: objectId}"
#need to know if this is different per subscription/account
variable "aro_rp_object_id" {
  type = string
  description = "ARO 4 Resource Provider Object ID"
  default = "464114b9-46ee-4c7c-a068-35ab76d50606"
}

variable "rp_roles" {
  description = "Roles to be assigned to the ARO Resource Provider Object ID"
  type        = list(object({ role = string }))
  default = [
    {
      role = "Contributor"
    }
  ]
}

variable "pull_secret_file_path" {
  type = string
  description = "Azure Openshift Pull Secret file path"
}

variable "subscription_id" {
  type = string
  description = "Subscription ID"
}