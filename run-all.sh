
echo 'Full automated script to setup an AKS demo environment'
echo ' '
echo ' It will create:'
echo ' - A resource group'
echo ' - A Azure Container Registry'
echo ' - An AKS cluster with'
echo '      - AAD V2 integration'
echo '      - autoscaling'
echo '      - KEDA'
echo '      - CSI driver for keyvault'
echo '      - KURed'
echo ' - several additional Demo applications:'
echo '   - showing keda'
echo '   - keyvault with CSI driver'
echo '   - network policy'
echo '   - prometheus monitorin'
. ./tools/functions.sh

deleteFile test.txt
. ./init/prep-tools.sh

echo ' '
echo  -e '\e[93mDefining variables\e[0m'
. variables.sh

echo ' '
echo -e '\e[93mCreating resources\e[0m'
. ./creation/create-rg.sh
. ./creation/create-acr.sh
. ./creation/create-aks.sh
. ./creation/create-kv.sh

echo ' '
echo -e '\e[93mConfiguring tools for cluster\e[0m'
. ./configuration/_install-configuration.sh

echo ' '
echo -e '\e[93mInstalling applications\e[0m'
 . ./app/_install-apps.sh

echo ' '
 . ./monitoring/monitoring.sh

echo ''
echo  -e '\e[93mCleaning\e[0m'
 . ./clean/clean.sh