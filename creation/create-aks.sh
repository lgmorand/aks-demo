aciinstallation="$(az provider list --query "[?contains(namespace,'Microsoft.ContainerInstance')].{State:registrationState}" -o tsv)"

if [[ "$aciinstallation" != "Registered" ]]
then 
    echo 'ACI provider installation..'
    az provider register --namespace Microsoft.ContainerInstance
    echo -e "\e[96mProvider installed\e[0m"
fi
echo -e "\e[95mDo you want to create the cluster? [y]es or [n]o\e[0m"

read answerCreateCluster
if [[ "$answerCreateCluster" == "y" ]]
then 
  echo 'AKS cluster creation...'
  az aks create \
    --resource-group $resourcegroup \
    --name $aksname \
    --node-count 1 \
    --vm-set-type VirtualMachineScaleSets \
    --load-balancer-sku standard \
    --enable-cluster-autoscaler \
    --cluster-autoscaler-profile scan-interval=15s \
    --min-count 1 \
    --max-count 3 
    --service-principal $spnAppId \
    --client-secret $spnPassword 
    #--node-resource-group $resourcegroupnodes
    #--enable-addons monitoring \ bug d'une extension https://github.com/Azure/azure-cli/issues/13121

  echo -e "\e[96mCluster created: " $aksname  "\e[0m"

  echo 'Enabling monitoring'
  az aks enable-addons -a monitoring -g $resourcegroup -n $aksname

  echo 'Attaching ACR to the cluster...'
  az aks update -n $aksname -g $resourcegroup --attach-acr $acrname
fi