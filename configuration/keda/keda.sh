echo 'KEDA installation'

kubectl delete ns keda --ignore-not-found

# Add the stable Helm repository
helm repo add kedacore https://kedacore.github.io/charts

# Update your local Helm chart repository cache
helm repo update

# Create a dedicated namespace where you would like to deploy kured into
kubectl create namespace keda

# Install KEDA in that namespace with Helm 3 
helm install keda kedacore/keda --namespace keda

echo -e "\e[96mKEDA installed\e[0m"
