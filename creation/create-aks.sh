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

  spnPassword="$(az ad sp create-for-rbac --name $aksSpn --skip-assignment --query password -o tsv)"
  spnAppId="$(az ad sp show --id $aksSpn --query appId -o tsv)"
  echo -e "Service Principal created is : \e[96m" $aksSpn  "\e[0m"
  echo -e "AppId : \e[96m" $spnAppId  "\e[0m"
  echo -e "Password: \e[96m" $spnPassword  "\e[0m"

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
    --max-count 3 
    --service-principal $spnAppId \
    --client-secret $spnPassword 
    #--node-resource-group $resourcegroupnodes
    #--enable-addons monitoring \ bug d'une extension https://github.com/Azure/azure-cli/issues/13121

  echo -e "\e[92mCluster created: " $aksName  "\e[0m"

  echo 'Addning another nodepool'
  az aks nodepool add \
    --resource-group $resourceGroup \
    --cluster-name $aksName \
    --name appnodepool \
    --node-count 1 \
    --mode user \
    --node-vm-size Standard_DS2_v2

  
  echo 'Enabling monitoring'
  az aks enable-addons -a monitoring -g $resourceGroup -n $aksName

  echo 'Attaching ACR to the cluster...'
  az aks update -n $aksName -g $resourceGroup --attach-acr $acrName
fi