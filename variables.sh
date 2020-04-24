subscriptionid='6c9dc160-dca4-47cb-9e76-ed16a4b4edb1'
echo -e "subscription ID is : \e[96m" $subscriptionid  "\e[0m"

location=westeurope 
echo -e "location is : \e[96m" $location  "\e[0m"

resourceGroup=rg-aks-test
echo -e "Name of the resource group is: \e[96m" $resourceGroup "\e[0m"

resourceGroupNodes=rg-aks-test-nodes
echo -e "Name of the resource group is: \e[96m" $resourceGroupNodes "\e[0m"

acrName=acrakstestlg
echo -e "Name of ACR is: \e[96m" $acrName "\e[0m"

aksName=aks-test
echo -e "Name of AKS is: \e[96m" $aksName "\e[0m"

aksSpn=http://aks-test-spn
echo -e "Name of AKS SPN is: \e[96m" $aksSpn "\e[0m"


####################
# Applications
####################

appEventSbName=sb-event-app
echo -e "Name of service bus for event-app is: \e[96m" $appEventSbName "\e[0m"