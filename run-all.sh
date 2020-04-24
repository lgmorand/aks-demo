
echo 'Full automated script to setup an AKS demo environment'
echo ' '
echo ' It will create:'
echo ' - A resource group'
echo ' - A Azure Container Registry'
echo ' - An AKS cluster with'
echo '      - AAD V2 integration'
echo '      - autoscaling'
echo '      - KEDA'
echo '      - flexvolume for keyvault'
echo '      - KURed'

. ./init/prep-tools.sh

echo ' '
echo  -e '\e[32mDefining variables\e[0m'
. variables.sh

echo ' '
echo -e '\e[32mCreating resources\e[0m'
. ./creation/create-rg.sh
. ./creation/create-spn.sh
. ./creation/create-acr.sh
. ./creation/create-aks.sh

echo ' '
echo -e '\e[32mConfiguring tools for cluster\e[0m'
. ./configuration/connection.sh
. ./configuration/kured.sh
. ./configuration/keda.sh
. ./configuration/ingress-controller.sh


echo ''
echo  -e '\e[32mCleaning\e[0m'
. ./clean/clean.sh