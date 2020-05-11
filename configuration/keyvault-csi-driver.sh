echo 'Installing keyvault CSI driver'

helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts

helm install csi-secrets-store-provider-azure/csi-secrets-store-provider-azure --generate-name
echo -e '\e[96mCSI driver installed\e[0m'