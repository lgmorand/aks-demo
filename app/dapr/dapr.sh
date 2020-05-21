DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

echo 'Dapr-app installation'

# Create a Managed Redis Cache and a store component
az redis create --location $location --name $redisName --resource-group $resourceGroup --sku Basic --vm-size c0 --enable-non-ssl-port
export redisHostName="$(az redis show -n $redisName -g $resourceGroup --query hostName -o tsv)"
export redisAccessKey="$(az redis list-keys -n $redisName -g $resourceGroup --query primaryKey -o tsv)"
envsubst < $DIR/redis-store-source.yaml > $DIR/redis-store.yaml
kubectl apply -f redis-store.yaml -n dapr
deleteFile $DIR/redis-store.yaml

echo -e "\e[96mDapr-app installed\e[0m"