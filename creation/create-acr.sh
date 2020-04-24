az acr create --resource-group $resourcegroup --name $acrname --sku Basic
echo -e "\e[96mACR created :" $acrname  "\e[0m"