# create a KV
az keyvault create --name $kvName --resource-group $resourceGroup --sku standard --location $location --enable-soft-delete false
