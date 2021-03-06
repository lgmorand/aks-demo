VARIABLE_MODULE='loaded'

####################
# Global
####################

debugMode=true
echo -e "Debug mode is : \e[96m" $debugMode "\e[0m"

####################
# AKS
####################

export subscriptionId='6c9dc160-dca4-47cb-9e76-ed16a4b4edb1'
echo -e "subscription ID is : \e[96m" $subscriptionId "\e[0m"

export tenantId='72f988bf-86f1-41af-91ab-2d7cd011db47'
echo -e "tenant ID is : \e[96m" $tenantId "\e[0m"

export tags="project=aks-test"
echo -e "tags: \e[96m" $tags  "\e[0m"

export location=westeurope 
echo -e "location is : \e[96m" $location  "\e[0m"

export resourceGroup=rg-aks-test
echo -e "Name of the resource group is: \e[96m" $resourceGroup "\e[0m"

export resourceGroupNodes=rg-aks-test-nodes
echo -e "Name of the resource group is: \e[96m" $resourceGroupNodes "\e[0m"

export acrName=acrakstestlg
echo -e "Name of ACR is: \e[96m" $acrName "\e[0m"

export aksName=aks-test
echo -e "Name of AKS is: \e[96m" $aksName "\e[0m"

export aksSpn=http://aks-test-spn
echo -e "Name of AKS SPN is: \e[96m" $aksSpn "\e[0m"

export aksLogWorkspace=log-aks-test-lg
echo -e "Name of AKS Log Workspace is: \e[96m" $aksLogWorkspace "\e[0m"

export aksVersion='1.16.7'
echo -e "AKS version is: \e[96m" $aksVersion "\e[0m"


####################
# Resources
####################

export kvName=kv-aks-test-lg
echo -e "Name of KeyVault is: \e[96m" $kvName "\e[0m"

export identityName=identity-aks-test-lg
echo -e "Name of the identity is: \e[96m" $identityName "\e[0m"

####################
# Applications
####################

export appEventSbName=sb-event-app
echo -e "Name of service bus for event-app is: \e[96m" $appEventSbName "\e[0m"

export redisName=redis-dapr-app
echo -e "Name of Redis Cache for dapr-app is: \e[96m" $redisName "\e[0m"