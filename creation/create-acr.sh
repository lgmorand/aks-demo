az acr create --resource-group $resourceGroup --name $acrName --sku Basic > /dev/null
echo -e "\e[96mACR created :" $acrName  "\e[0m"