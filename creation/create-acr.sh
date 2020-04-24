az acr create --resource-group $resourceGroup --name $acrName --sku Basic
echo -e "\e[96mACR created :" $acrName  "\e[0m"