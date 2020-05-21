. ../variables.sh

echo -e "\e[95mDo you want to delete the cluster and all related components ? [y]es or [n]o\e[0m"

read answerCreateCluster
if [[ "$answerCreateCluster" == "y" ]]
then 
    # delete the SPN
    az ad sp delete --id $aksSpn
    echo "SPN deleted"

    # delete the RG
    echo "Deleting resource group (can be very long)..."
    az group delete --name $resourceGroup --yes
    echo "Resource group deleted"

    echo "All resources have been deleted"
else
    echo "You want to keep them ? As you want boss !"
fi
