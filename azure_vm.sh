#!/bin/bash

AZURE_RESOURCE_GROUP= $2

if [ $1 == "start" ];
then
    VM_NAMES=$(az vm list -g $AZURE_RESOURCE_GROUP --show-details --query "[?powerState=='VM deallocated'].{ name: name }" -o tsv)
    for NAME in $VM_NAMES
    do
        echo "Starting $NAME"
        az vm start -n $NAME -g $AZURE_RESOURCE_GROUP --no-wait
    done
fi

if [ $1 == "stop" ];
then
    VM_NAMES=$(az vm list -g $AZURE_RESOURCE_GROUP --show-details --query "[?powerState=='VM running'].{ name: name }" -o tsv)
    for NAME in $VM_NAMES
    do
        echo "Stopping $NAME"
        az vm deallocate -n $NAME -g $AZURE_RESOURCE_GROUP --no-wait
    done
fi

if [ $1 == "status" ];
then
    echo "Fetching Details..."
    az vm list -g $AZURE_RESOURCE_GROUP --show-details
    echo "Fetching Summary..."
    echo "Power Status of all VMs"
    echo "-----------------------"
    az vm list -g $AZURE_RESOURCE_GROUP --show-details --query "[].{name: name, status: powerState}" -o table
fi


if [ $1 == "ip" ];
then
    az vm list -g $AZURE_RESOURCE_GROUP --show-details --query "[?powerState=='VM running'].{ name:name, ip: publicIps }" -o table
fi
