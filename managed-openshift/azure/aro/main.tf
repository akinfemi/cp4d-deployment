resource "azurerm_template_deployment" "azure-arocluster" {
  name  = var.cluster_name
  resource_group_name = var.resource_group

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "type": "string"
        },
        "azClientId": {
            "type": "string"
        },
        "azClientSecret": {
            "type": "string"
        },
        "clusterName": {
            "defaultValue": "arocluster",
            "type": "string"
        },
        "apiServerVisibility": {
            "type": "string"
        },
        "ingressVisibility": {
            "type": "string"
        },
        "virtualNetworkCIDR": {
            "type": "string"
        },
        "masterSubnetID": {
            "type": "string"
        },
        "workerSubnetID": {
            "type": "string"
        },
        "domain": {
            "type": "string"
        },
        "masterVmSize": {
            "type": "string",
            "defaultValue": "Standard_D8s_v3"
        },
        "workerVmSize": {
            "type": "string",
            "defaultValue": "Standard_D16s_v3"
        },
        "workerVmCount": {
            "type": "string",
            "defaultValue": "3"
        },
        "workerVmDiskSize": {
            "type": "string",
            "defaultValue": "128"
        },
        "resourceGroupId": {
            "type": "string"
        }
    },
    "variables": {
        "serviceCidr": "192.30.0.0/16",
        "cidr-prefix": "[split(parameters('virtualNetworkCIDR'), '.')[0]]",
		"podCidr": "[concat(variables('cidr-prefix'), '.128.0.0/14')]"
    },
    "resources": [
        {
            "apiVersion": "2019-05-01",
            "name": "pid-06f07fff-296b-5beb-9092-deab0c6bb8ea",
            "type": "Microsoft.Resources/deployments",
            "properties": {
                "mode": "Incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "resources": [
                    ]
                }
            }
        },
        {
            "type": "Microsoft.RedHatOpenShift/openShiftClusters",
            "apiVersion": "2020-04-30",
            "name": "[parameters('clusterName')]",
            "location": "[parameters('location')]",
            "properties": {
                "clusterProfile": {
                    "domain": "[parameters('domain')]",
                    "resourceGroupId": "[parameters('resourceGroupId')]"
                },
                "servicePrincipalProfile": {
                    "clientId": "[parameters('azClientId')]",
                    "clientSecret": "[parameters('azClientSecret')]"
                },
                "networkProfile": {
                    "podCidr": "[variables('podCidr')]",
                    "serviceCidr": "[variables('serviceCidr')]"
                },
                "masterProfile": {
                    "vmSize": "[parameters('masterVmSize')]",
                    "subnetId": "[parameters('masterSubnetID')]"
                },
                "workerProfiles": [
                    {
                        "name": "worker",
                        "vmSize": "[parameters('workerVmSize')]",
                        "diskSizeGB": "[int(parameters('workerVmDiskSize'))]",
                        "subnetId": "[parameters('workerSubnetID')]",
                        "count": "[int(parameters('workerVmCount'))]"
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
    ]
}
  DEPLOY

  parameters = {
    "location" = var.region
    "azClientId" = var.azure_client_id
    "azClientSecret" = var.azure_client_secret
    "clusterName" = var.cluster_name
    "apiServerVisibility" = var.api_server_visibility
    "ingressVisibility" = var.ingress_visibility
    "virtualNetworkCIDR" = var.virtual_network_cidr
    "masterSubnetID" = var.master_subnet_id
    "workerSubnetID" = var.worker_subnet_id
    "domain" = var.dns_zone_name
    "masterVmSize" = var.master_vm_size
    "workerVmSize" = var.worker_vm_size
    "workerVmCount" = var.worker_vm_count
    "workerVmDiskSize" = var.worker_vm_disk_size
    "resourceGroupId" = var.resource_group_id
  }
  deployment_mode = "Incremental"
}