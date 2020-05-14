echo 'Dapr installation'

helm repo add dapr https://daprio.azurecr.io/helm/v1/repo
helm repo update
kubectl create namespace dapr-system
helm install dapr dapr/dapr --namespace dapr-system

echo -e "\e[96mDapr installed\e[0m"