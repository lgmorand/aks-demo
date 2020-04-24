echo -e "\e[95mDo you want to install tools (Azure CLI, kubectl, HELM, etc.) [y]es or [n]o\e[0m"

read answerInstallTools
if [[ "$answerInstallTools" == "y" ]]
then 
    ######################
    # Install azure CLI
    ######################

    echo 'Installing CLI...'
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

    ####################
    # CLI extensions Installation
    ####################
    echo 'Installing CLI extensions...'
    az extension add --name aks-preview
    az extension update --name aks-preview

    ######################
    # Kubectl Installation
    ######################
    
    echo 'Install kubectl'
    sudo apt-get install -y apt-transport-https

    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo touch /etc/apt/sources.list.d/kubernetes.list 
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    kubectl api-versions


    # set up autocomplete for kubectl
    source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
    echo "source <(kubectl completion bash)" >> ~/.bashrc 
    alias k=kubectl
    complete -F __start_kubectl k


    ####################
    # HELM Installation
    ####################
    
    echo 'Installing helm...'
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh

fi