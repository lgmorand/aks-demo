DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

[ -z "$FUNCTION_MODULE" ] && . "../../tools/functions.sh"

echo 'Enabling pod identity'

# install pod identity components
kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/deployment-rbac.yaml
#running twice just in case
kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/deployment-rbac.yaml

export keyvaultResourceId="$(az keyvault show -g $resourceGroup -n $kvName  --query id -otsv)"

# creation of entity
echo 'creating identity'
az identity create -g $resourceGroup -n $identityName 
export identityClientId="$(az identity show -g $resourceGroup -n $identityName  --query clientId -otsv)"
export identityResourceId="$(az identity show -g $resourceGroup -n $identityName  --query id -otsv)"
export identityPrincipalId="$(az identity show -g $resourceGroup -n $identityName  --query principalId -otsv)"

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
envsubst < $DIR/aadpodidentity-source.yaml > $DIR/aadpodidentity-generated.yaml
kubectl apply -f "$DIR/aadpodidentity-generated.yaml"
deleteFile "$DIR/aadpodidentity-generated.yaml"
