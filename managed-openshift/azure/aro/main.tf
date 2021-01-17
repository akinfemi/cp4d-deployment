# resource "azurerm_role_assignment" "client_id_assignment" {
#   count			= length(var.roles)
#   scope			= var.subscription_id
#   role_definition_name	= var.roles[count.index].role
#   principal_id		= var.client_object_id
# }

# resource "azurerm_role_assignment" "rp_assignment" {
#   count			= length(var.rp_roles)
#   scope			= var.virtual_network_id
#   role_definition_name	= var.roles[count.index].role
#   principal_id		= var.aro_rp_object_id
# }

resource "azurerm_template_deployment" "azure-arocluster" {
  name  = var.cluster_name
  resource_group_name = var.resource_group

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "defaultValue": "eastus",
            "type": "String",
            "metadata": {
                "description": "Location"
            }
        },
        "domain": {
            "defaultValue": "",
            "type": "String",
            "metadata": {
                "description": "Domain Prefix"
            }
        },
        "pullSecret": {
            "type": "String",
            "metadata": {
                "description": "Pull secret from cloud.redhat.com. The json should be input as a string"
            }
        },
        "clusterVnetName": {
            "defaultValue": "aro-vnet",
            "type": "String",
            "metadata": {
                "description": "Name of ARO vNet"
            }
        },
        "masterVmSize": {
            "defaultValue": "Standard_D8s_v3",
            "type": "String",
            "metadata": {
                "description": "Master Node VM Type"
            }
        },
        "workerVmSize": {
            "defaultValue": "Standard_D4s_v3",
            "type": "String",
            "metadata": {
                "description": "Worker Node VM Type"
            }
        },
        "workerVmDiskSize": {
            "defaultValue": 128,
            "minValue": 128,
            "type": "Int",
            "metadata": {
                "description": "Worker Node Disk Size in GB"
            }
        },
        "workerCount": {
            "defaultValue": 3,
            "minValue": 3,
            "type": "Int",
            "metadata": {
                "description": "Number of Worker Nodes"
            }
        },
        "podCidr": {
            "defaultValue": "10.128.0.0/14",
            "type": "String",
            "metadata": {
                "description": "Cidr for Pods"
            }
        },
        "serviceCidr": {
            "defaultValue": "172.30.0.0/16",
            "type": "String",
            "metadata": {
                "decription": "Cidr of service"
            }
        },
        "clusterName": {
            "type": "String",
            "metadata": {
                "description": "Unique name for the cluster"
            }
        },
        "tags": {
            "defaultValue": {
                "env": "Dev",
                "dept": "Ops"
            },
            "type": "Object",
            "metadata": {
                "description": "Tags for resources"
            }
        },
        "apiServerVisibility": {
            "defaultValue": "Public",
            "allowedValues": [
                "Private",
                "Public"
            ],
            "type": "String",
            "metadata": {
                "description": "Api Server Visibility"
            }
        },
        "ingressVisibility": {
            "defaultValue": "Public",
            "allowedValues": [
                "Private",
                "Public"
            ],
            "type": "String",
            "metadata": {
                "description": "Ingress Visibility"
            }
        },
        "aadClientId": {
            "type": "String",
            "metadata": {
                "description": "The Application ID of an Azure Active Directory client application"
            }
        },
        "aadObjectId": {
            "type": "String",
            "metadata": {
                "description": "The Object ID of an Azure Active Directory client application"
            }
        },
        "aadClientSecret": {
            "type": "SecureString",
            "metadata": {
                "description": "The secret of an Azure Active Directory client application"
            }
        },
        "rpObjectId": {
            "type": "String",
            "metadata": {
                "description": "The ObjectID of the Resource Provider Service Principal"
            }
        }
    },
    "variables": {
        "contribRole": "[concat('/subscriptions/', subscription().subscriptionId, '/providers/Microsoft.Authorization/roleDefinitions/', 'b24988ac-6180-42a0-ab88-20f7382dd24c')]"
    },
    "resources": [
        {
            "type": "Microsoft.Network/virtualNetworks/providers/roleAssignments",
            "apiVersion": "2018-09-01-preview",
            "name": "[concat(parameters('clusterVnetName'), '/Microsoft.Authorization/', guid(resourceGroup().id, deployment().name, parameters('aadObjectId')))]",
            "properties": {
                "roleDefinitionId": "[variables('contribRole')]",
                "principalId": "[parameters('aadObjectId')]"
            }
        },
        {
            "type": "Microsoft.Network/virtualNetworks/providers/roleAssignments",
            "apiVersion": "2018-09-01-preview",
            "name": "[concat(parameters('clusterVnetName'), '/Microsoft.Authorization/', guid(resourceGroup().id, deployment().name, parameters('rpObjectId')))]",
            "properties": {
                "roleDefinitionId": "[variables('contribRole')]",
                "principalId": "[parameters('rpObjectId')]"
            }
        },
        {
            "type": "Microsoft.RedHatOpenShift/OpenShiftClusters",
            "apiVersion": "2020-04-30",
            "name": "[parameters('clusterName')]",
            "location": "[parameters('location')]",
            "tags": "[parameters('tags')]",
            "properties": {
                "clusterProfile": {
                    "domain": "[parameters('domain')]",
                    "resourceGroupId": "[concat('/subscriptions/', subscription().subscriptionId,'/resourceGroups/aro-', parameters('domain'))]",
                    "pullSecret": "[parameters('pullSecret')]"
                },
                "networkProfile": {
                    "podCidr": "[parameters('podCidr')]",
                    "serviceCidr": "[parameters('serviceCidr')]"
                },
                "servicePrincipalProfile": {
                    "clientId": "[parameters('aadClientId')]",
                    "clientSecret": "[parameters('aadClientSecret')]"
                },
                "masterProfile": {
                    "vmSize": "[parameters('masterVmSize')]",
                    "subnetId": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('clusterVnetName'), 'master')]"
                },
                "workerProfiles": [
                    {
                        "name": "worker",
                        "vmSize": "[parameters('workerVmSize')]",
                        "diskSizeGB": "[parameters('workerVmDiskSize')]",
                        "subnetId": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('clusterVnetName'), 'worker')]",
                        "count": "[parameters('workerCount')]"
                    }
                ],
                "apiserverProfile": {
                    "visibility": "[parameters('apiServerVisibility')]"
                },
                "ingressProfiles": [
                    {
                        "name": "default",
                        "visibility": "[parameters('ingressVisibility')]"
                    }
                ]
            }
        }
    ],
    "outputs": {
        "clusterCredentials": {
            "type": "Object",
            "value": "[listCredentials(resourceId('Microsoft.RedHatOpenShift/OpenShiftClusters', parameters('clusterName')), '2020-04-30')]"
        },
        "oauthCallbackURL": {
            "type": "String",
            "value": "[concat('https://oauth-openshift.apps.', parameters('domain'), '.', parameters('location'), '.aroapp.io/oauth2callback/AAD')]"
        }
    }
}
  DEPLOY

  parameters = {
    "location" = var.region
    "domain" = var.dns_zone_name
    "pullSecret" = file(var.pull_secret_file_path)
    "clusterName" = var.cluster_name
    "aadClientId" = var.azure_client_id
    "aadClientSecret" = var.azure_client_secret
    "rpObjectId" = var.aro_rp_object_id
    "aadObjectId" = var.client_object_id
    "clusterVnetName" = var.virtual_network_name
    # "virtualNetworkCIDR" = var.virtual_network_cidr
    # "apiServerVisibility" = var.api_server_visibility
    # "ingressVisibility" = var.ingress_visibility
    # "masterSubnetID" = var.master_subnet_id
    # "workerSubnetID" = var.worker_subnet_id
    # "masterVmSize" = var.master_vm_size
    # "workerVmSize" = var.worker_vm_size
    # "workerVmCount" = var.worker_vm_count
    # "workerVmDiskSize" = var.worker_vm_disk_size
    # "resourceGroupId" = var.resource_group_id
    
  }
  deployment_mode = "Incremental"
}