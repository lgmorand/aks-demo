subscriptionid='6c9dc160-dca4-47cb-9e76-ed16a4b4edb1'
echo -e "subscription ID is : \e[96m" $subscriptionid  "\e[0m"

location=westeurope 
echo -e "location is : \e[96m" $location  "\e[0m"

resourcegroup=rg-aks-test
echo -e "Name of the resource group is: \e[96m" $resourcegroup "\e[0m"

resourcegroupnodes=rg-aks-test-nodes
echo -e "Name of the resource group is: \e[96m" $resourcegroupnodes "\e[0m"

acrname=acrakstestlg
echo -e "Name of ACR is: \e[96m" $acrname "\e[0m"

aksname=aks-test
echo -e "Name of AKS is: \e[96m" $aksname "\e[0m"

aksspn=http://aks-test-spn
echo -e "Name of AKS SPN is: \e[96m" $aksspn "\e[0m"
