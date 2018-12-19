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

. Create_Common_Config_Storage.sh


#templateFile Path - template file to be used
templateFilePath="template.json"

if [ ! -f "$templateFilePath" ]; then
	echo "$templateFilePath not found"
	exit 1
fi

#parameter file path
parametersFilePath="parameters.json"

if [ ! -f "$parametersFilePath" ]; then
	echo "$parametersFilePath not found"
	exit 1
fi

declare deploymentName=""
deploymentName="ACIDeploy"$ACI_PERS_RANDOM

#Start deployment
echo "Starting container creation..."
(
	set -x
	az group deployment create --name $deploymentName --resource-group $ACI_PERS_RESOURCE_GROUP \
     --template-file $templateFilePath --parameters @${parametersFilePath} \
     --parameters storageAccounts_sdccommon_name=$ACI_PERS_SHARED_STORAGE_ACCOUNT_NAME \
     --parameters shareMountPath=$ACI_PERS_SHARED_CONFIG_PATH \
     --parameters shareMountName=$ACI_PERS_SHARED_CONFIG_NAME \
     --parameters storageAccounts_sdccommon_key=$SHARED_STORAGE_KEY \
     --parameters containerGroups_sdc_name=$ACI_PERS_RANDOM \
     --parameters storageAccounts_containerstorage_name=$ACI_PERS_STORAGE_ACCOUNT_NAME \
     --parameters storageAccounts_containerstorage_key=$STORAGE_KEY \
     --parameters sharedConfigPath=$ACI_PERS_SHARED_CONFIG_PATH \
)

if [ $?  == 0 ];
 then
	echo "Template has been successfully deployed"
fi