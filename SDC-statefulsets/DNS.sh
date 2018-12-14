#!/bin/bash

# Public IP address of your ingress controller
PUBLICIPID="40.78.155.146"

# Name to associate with public IP address
DNSNAME="wws-agrisync-sdc"

SUBSCRIPTION="92087953-a693-48bc-9c40-249dd9cd1029"

# Get the resource-id of the public ip
PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

# Update public ip address with DNS name
az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME --subscription $SUBSCRIPTION
