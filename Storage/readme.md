# Persistent Storage in Azure #

I wanted to create a storage location that every pod/service has access to.  This way, there is persistent storage if services are not.

[Based on this Microsoft Doc](https://docs.microsoft.com/en-us/azure/aks/azure-disks-dynamic-pv)

## Create storage account from template ##
az group deployment create --template-file template.json --parameters parameters.json --resource-group AKSCluster
