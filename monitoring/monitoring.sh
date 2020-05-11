echo 'Monitoring configuration'
echo 'Disabling stoud logs : [log_collection_settings.stdout] false'
echo 'Disable env var [log_collection_settings.env_var]  false'
kubectl apply -f container-azm-ms-agentconfig.yaml

echo -e "\e[96mMonitoring configured\e[0m"