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

 . ./creation/create-spn.sh

  echo 'AKS cluster creation...'
  az aks create \
    --resource-group $resourceGroup \
    --name $aksName \
    --node-count 1 \
    --vm-set-type VirtualMachineScaleSets \
    --load-balancer-sku standard \
    --enable-cluster-autoscaler \
    --cluster-autoscaler-profile scan-interval=15s \
    --min-count 1 \
    --max-count 3 \
    --service-principal $spnAppId \
    --client-secret $spnPassword \
    --network-policy calico \
    --network-plugin kubenet \
    --node-resource-group $resourceGroupNodes \
    --kubernetes-version 1.16.7 \
    --tags $tags

  echo -e "\e[92mCluster created: " $aksName  "\e[0m"

  echo 'Adding another nodepool'
  az aks nodepool add \
    --resource-group $resourceGroup \
    --cluster-name $aksName \
    --name appnodepool \
    --node-count 1 \
    --mode user \
    --node-vm-size Standard_DS2_v2 \
    --tags $tags 

  
  echo 'Enabling monitoring'
  az monitor log-analytics workspace create -g $resourceGroup -n $aksLogWorkspace -l $location --tags $tags
  wksResourceId="$(az monitor log-analytics workspace show --resource-group $resourceGroup --workspace-name $aksLogWorkspace --query id -o tsv)"
  az aks enable-addons -a monitoring -g $resourceGroup -n $aksName --workspace-resource-id $wksResourceId

  echo 'Attaching ACR to the cluster...'
  az aks update -n $aksName -g $resourceGroup --attach-acr $acrName

  echo 'Cluster fully configured'
fi