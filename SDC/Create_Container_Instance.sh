ACI_PERS_RESOURCE_GROUP=ACICluster
ACI_PERS_RANDOM=$RANDOM
ACI_PERS_STORAGE_ACCOUNT_NAME=containerstorage$ACI_PERS_RANDOM
ACI_PERS_LOCATION=centralus
ACI_PERS_SHARE_NAME=sdcconf
ACI_PERS_SUBSCRIPTION=92087953-a693-48bc-9c40-249dd9cd1029

echo ##############################################)
echo Creating the storage account
echo ##############################################

az storage account create --subscription $ACI_PERS_SUBSCRIPTION --resource-group $ACI_PERS_RESOURCE_GROUP --name $ACI_PERS_STORAGE_ACCOUNT_NAME --location $ACI_PERS_LOCATION --sku Standard_LRS

echo ##############################################
echo Creating the file share from new storage account
echo ##############################################
az storage share create --name etc --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME
az storage share create --name data --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME

STORAGE_KEY=$(az storage account keys list --subscription $ACI_PERS_SUBSCRIPTION --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME --query "[0].value"  --output tsv)

ACI_PERS_CONATINER_NAME=sdc-$ACI_PERS_RANDOM

echo ##############################################
echo Create Container

#
#az group deployment create --name "$ACI_PERS_CONATINER_NAME" --resource-group "$ACI_PERS_RESOURCE_GROUP" --template-file "template/template.json" --parameters "template/parameters.json"



#az container create \
    #--subscription $ACI_PERS_SUBSCRIPTION \
    #--resource-group $ACI_PERS_RESOURCE_GROUP \
    #--name $ACI_PERS_CONATINER_NAME \
    #--image rwetzeler/streamsets-dc \
    #--dns-name-label $ACI_PERS_CONATINER_NAME \
    #--ports 18630 \
