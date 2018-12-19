#### Author: Rob Wetzeler <rob.wetzeler@gmail.com>
#### Wetzeler Web Services
echo "                    (     ";
echo " (  (     (  (      )\ )  ";
echo " )\))(   ')\))(   '(()/(  ";
echo "((_)()\ )((_)()\ )  /(_)) ";
echo "_(())\_)()(())\_)()(_))   ";
echo "\ \((_)/ | \((_)/ // __|  ";
echo " \ \/\/ / \ \/\/ / \__ \  ";
echo "  \_/\_/   \_/\_/  |___/  ";
#
# TODO:
# * Parmertize SubscriptionID and ask for optional shared storage creation
# * Convert all of this to ARM template vs. a combination
# * Rework storage create for container storage to leverage a common
#   script between single and multiple volume (../Create_Container_Instance.sh) 

ACI_PERS_RESOURCE_GROUP=ACICluster
ACI_PERS_RANDOM=$RANDOM
ACI_PERS_SHARED_STORAGE_ACCOUNT_NAME=sdcshrd$ACI_PERS_RANDOM #for shared config
ACI_PERS_STORAGE_ACCOUNT_NAME=containerstorage$ACI_PERS_RANDOM #for container persistent storage
ACI_PERS_LOCATION=centralus
ACI_PERS_SHARED_CONFIG_NAME=sharedconfig #for shared config volume mount path
ACI_PERS_SHARED_CONFIG_PATH=$ACI_PERS_SHARED_CONFIG_NAME'/sdc/etc/conf'
ACI_PERS_SHARE_NAME=mnt #for container volume persistent storage

ACI_PERS_SUBSCRIPTION=92087953-a693-48bc-9c40-249dd9cd1029

## Goal - Create the Common Store - cp all common config, then the SDC can use that as a mount via SDC_CONF path (e.g. /mnt/sdc/conf)
## The idea of this is that this storage can be shared across multiple SDC instance, vs. other persistant storage should be 1to1 bound to SDC instance


echo
echo
echo '**********************************************'
echo '**********************************************'
echo 'Starting Job - All Resources will have postfix:' $ACI_PERS_RANDOM
echo '**********************************************'
echo '**********************************************'
echo
echo
echo '**********************************************'
echo 'Creating the storage account -' $ACI_PERS_SHARED_STORAGE_ACCOUNT_NAME
echo '**********************************************'

az storage account create --subscription $ACI_PERS_SUBSCRIPTION --resource-group $ACI_PERS_RESOURCE_GROUP --name $ACI_PERS_SHARED_STORAGE_ACCOUNT_NAME --location $ACI_PERS_LOCATION --sku Standard_LRS
echo
echo
echo '**********************************************'
echo 'Creating the file share from new storage account (shared storage)'
echo '**********************************************'
az storage share create --name $ACI_PERS_SHARED_CONFIG_NAME --account-name $ACI_PERS_SHARED_STORAGE_ACCOUNT_NAME

SHARED_STORAGE_KEY=$(az storage account keys list --subscription $ACI_PERS_SUBSCRIPTION --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $ACI_PERS_SHARED_STORAGE_ACCOUNT_NAME --query "[0].value"  --output tsv)
echo Key: $SHARED_STORAGE_KEY

echo
echo
echo '**********************************************'
echo 'Creating the container storage account -' $ACI_PERS_STORAGE_ACCOUNT_NAME
echo '**********************************************'

az storage account create --subscription $ACI_PERS_SUBSCRIPTION --resource-group $ACI_PERS_RESOURCE_GROUP --name $ACI_PERS_STORAGE_ACCOUNT_NAME --location $ACI_PERS_LOCATION --sku Standard_LRS

echo
echo
echo '**********************************************'
echo 'Creating the file share from new storage account (container storage)'
echo '**********************************************'
az storage share create --name $ACI_PERS_SHARE_NAME --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME

STORAGE_KEY=$(az storage account keys list --subscription $ACI_PERS_SUBSCRIPTION --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME --query "[0].value"  --output tsv)
echo Key: $STORAGE_KEY

echo
echo
echo '**********************************************'
echo 'Now that storage is created, Copy the shared Config'
echo '**********************************************'
# I do this in case I need to tweak an SDC intance config.
#Alternative is to map direct config path and then all instances should be read only

#if no config is already stored within Azure Shared Config
az storage file upload-batch --destination $ACI_PERS_SHARED_CONFIG_NAME --destination-path $ACI_PERS_SHARED_CONFIG_PATH --source '../SDC_Config' --account-name $ACI_PERS_SHARED_STORAGE_ACCOUNT_NAME --account-key $SHARED_STORAGE_KEY

echo
echo
echo '**********************************************'
echo Create Container w/Azure Storage - Multiple Volume Mount via Azure Resource Manager
echo '**********************************************'
 
