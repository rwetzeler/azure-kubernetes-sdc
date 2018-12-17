#!/bin/bash
set -uo pipefail
IFS=$'\n\t'

declare resourceGroupName="ACICluster"
declare deploymentName="Template-Deploy-$RANDOM"
declare resourceGroupLocation="centralus"

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

# Initialize parameters specified from command line
while getopts ":g:n:" arg; do
	case "${arg}" in
		g)
			resourceGroupName=${OPTARG}
			;;
		n)
			deploymentName=${OPTARG}
			;;

		esac
done
shift $((OPTIND-1))

#Prompt for parameters is some required parameters are missing

if [[ -z "$resourceGroupName" ]]; then
	echo "This script will look for an existing resource group, otherwise a new one will be created "
	echo "You can create new resource groups with the CLI using: az group create "
	echo "Enter a resource group name"
	read resourceGroupName
	[[ "${resourceGroupName:?}" ]]
fi

if [[ -z "$deploymentName" ]]; then
	echo "Enter a name for this deployment:"
	read deploymentName
fi


#Check for existing RG
az group show --name $resourceGroupName 1> /dev/null

if [ $? != 0 ]; then
	echo "Resource group with name" $resourceGroupName "could not be found. Creating new resource group.."
	set -e
	(
		set -x
		az group create --name $resourceGroupName --location $resourceGroupLocation 1> /dev/null
	)
	else
	echo "Using existing resource group..."
fi


#Start deployment
echo "Starting deployment..."

set -e
(
	set -x
	az group deployment create --name "$deploymentName" --resource-group $resourceGroupName  --template-file "$templateFilePath" --parameters "$parametersFilePath"
)


if [ $?  == 0 ];
 then
		echo "Template has been successfully deployed"
	else
		echo "Failed deploy"
		exit 0
fi
