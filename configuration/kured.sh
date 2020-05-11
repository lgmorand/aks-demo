echo 'Kured installation'

kubectl delete ns kured --ignore-not-found

# Add the stable Helm repository
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Update your local Helm chart repository cache
helm repo update

# Create a dedicated namespace where you would like to deploy kured into
kubectl create namespace kured

# Install kured in that namespace with Helm 3 (only on Linux nodes, kured is not working on Windows nodes)
helm install kured stable/kured --namespace kured --set nodeSelector."beta\.kubernetes\.io/os"=linux,extraArgs.reboot-days="Mon\,Tue"

echo -e "\e[96mKured installed\e[0m"