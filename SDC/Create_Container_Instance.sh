ACI_PERS_RESOURCE_GROUP=ACICluster
ACI_PERS_RANDOM=$RANDOM
ACI_PERS_STORAGE_ACCOUNT_NAME=containerstorage$ACI_PERS_RANDOM
ACI_PERS_LOCATION=centralus
ACI_PERS_SHARE_NAME=mnt
ACI_PERS_SUBSCRIPTION=92087953-a693-48bc-9c40-249dd9cd1029

echo ##############################################)
echo Creating the storage account - $ACI_PERS_STORAGE_ACCOUNT_NAME
echo ##############################################

az storage account create --subscription $ACI_PERS_SUBSCRIPTION --resource-group $ACI_PERS_RESOURCE_GROUP --name $ACI_PERS_STORAGE_ACCOUNT_NAME --location $ACI_PERS_LOCATION --sku Standard_LRS


echo ##############################################
echo Creating the file share from new storage account
echo ##############################################
az storage share create --name $ACI_PERS_SHARE_NAME --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME

STORAGE_KEY=$(az storage account keys list --subscription $ACI_PERS_SUBSCRIPTION --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME --query "[0].value"  --output tsv)
echo Key: $STORAGE_KEY

ACI_PERS_CONATINER_NAME=sdc-$ACI_PERS_RANDOM

echo ##############################################
echo Create Container w/Azure Storage
echo ##############################################

az container create \
    --subscription $ACI_PERS_SUBSCRIPTION \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_CONATINER_NAME \
    --image rwetzeler/streamsets-dc \
    --dns-name-label $ACI_PERS_CONATINER_NAME \
    --ports 18630 \
     --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /mnt \
    --environment-variables 'SDC_DATA'='/mnt/sdc/data' 'SDC_LOG'='/mnt/sdc/logs'    

