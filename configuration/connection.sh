echo 'Trying to connect to cluster'

az aks get-credentials -n $aksname -g $resourcegroup

connectionStatus=$(kubectl version)

if [[ $connectionStatus == *"Server Version: "* ]]; then
    echo -e "\e[92mconnexion successful\e[0m"
else
    echo -e "\e[91mUnable to connect to cluster\e[0m"
fi