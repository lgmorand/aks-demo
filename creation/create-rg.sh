az group create --name $resourceGroup --location $location > /dev/null
resourceGroupId="$(az group show --name $resourceGroup --query id -o tsv)"
echo -e "\e[96mResource group created: " $resourceGroup  "\e[0m"