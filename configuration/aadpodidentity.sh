echo 'Enabling pod identity'

# create a KV
az keyvault create --name $kvName --resource-group $resourceGroup --sku standard --location $location --enable-soft-delete false

# install pod identity components
kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/deployment-rbac.yaml
#running twice just in case
kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/deployment-rbac.yaml

keyvaultResourceId="$(az keyvault show -g $resourceGroup -n $kvName  --query id -otsv)"

# creation of entity
echo 'creating identity'
az identity create -g $resourceGroup -n $identityName 
identityClientId="$(az identity show -g $resourceGroup -n $identityName  --query clientId -otsv)"
identityResourceId="$(az identity show -g $resourceGroup -n $identityName  --query id -otsv)"
identityPrincipalId="$(az identity show -g $resourceGroup -n $identityName  --query principalId -otsv)"

echo 'Assign Cluster SPN Role' 
az role assignment create --role "Managed Identity Operator" --assignee $aksSpn --scope $identityResourceId

# Assign Azure Identity Roles
echo 'Assign Reader Role to new Identity for your Key Vault' 
az role assignment create --role Reader --assignee $identityPrincipalId --scope $keyvaultResourceId


# set policy to access keys in your Key Vault
az keyvault set-policy -n $kvName --key-permissions get --spn $identityClientId
# set policy to access secrets in your Key Vault
az keyvault set-policy -n $kvName --secret-permissions get --spn $identityClientId
# set policy to access certs in your Key Vault
az keyvault set-policy -n $kvName --certificate-permissions get --spn $identityClientId

# deploying identity
cp ./configuration/aadpodidentity-source.yaml ./configuration/aadpodidentity.yaml # create a copy to replace variables in
sed -i "s/IDENTITY_NAME_TOKEN/$identityName/g" ./configuration/aadpodidentity.yaml
sed -i "s~IDENTITY_RESOURCE_ID_TOKEN~$identityResourceId~g" ./configuration/aadpodidentity.yaml
sed -i "s/CLIENT_ID_TOKEN/$identityClientId/g" ./configuration/aadpodidentity.yaml
kubectl apply -f ./configuration/aadpodidentity.yaml
rm -f ./configuration/aadpodidentity.yaml
