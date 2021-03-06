DIR_APPS="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR_APPS" ]]; then DIR_APPS="$PWD"; fi

[ -z "$FUNCTION_MODULE" ] && . "../tools/functions.sh"

echo 'Installing hello world application'
kubectl delete ns hello-world --ignore-not-found
kubectl apply -f $DIR_APPS/hello-world/
echo -e '\e[96mHello world app installed\e[0m'

echo 'Installing netpol application'
kubectl delete ns netpol --ignore-not-found
kubectl apply -f $DIR_APPS/netpol
echo -e '\e[93mDelete netpol back-end-allow-from-front to break the website\e[0m'
echo -e '\e[96mnetpol app installed\e[0m'

echo 'Installing monitored application'
kubectl delete ns monitor --ignore-not-found
kubectl apply -f $DIR_APPS/monitor
echo -e '\e[96mmonitor app installed\e[0m'

echo 'Installing keyvault application'
kubectl delete ns keyvault --ignore-not-found
az keyvault secret set --vault-name $kvName --name "my-secret" --value "I'm a secret from keyvault"
envsubst < $DIR/keyvault/keyvault-source.yaml > $DIR/keyvault/keyvault-generated.yaml
envsubst < $DIR/keyvault/aadpodidentitybinding-source.yaml > $DIR/keyvault/aadpodidentitybinding-generated.yaml
# cp $DIR_APPS/keyvault/keyvault-source.yaml $DIR_APPS/keyvault/keyvault.yaml # create a copy to replace variables in
# cp $DIR_APPS/keyvault/aadpodidentitybinding-source.yaml $DIR_APPS/keyvault/aadpodidentitybinding.yaml # create a copy to replace variables in
# sed -i "s/RESOURCE_GROUP_TOKEN/$resourceGroup/g" ./app/keyvault/keyvault.yaml
# sed -i "s/SUBSCRIPTION_ID_TOKEN/$subscriptionId/g" ./app/keyvault/keyvault.yaml
# sed -i "s/TENANT_ID_TOKEN/$tenantId/g" ./app/keyvault/keyvault.yaml
# sed -i "s/KEYVAULT_NAME_TOKEN/$kvName/g" ./app/keyvault/keyvault.yaml
# sed -i "s/IDENTITY_NAME_TOKEN/$identityName/g" ./app/keyvault/aadpodidentitybinding.yaml
kubectl apply -f ./app/keyvault/aadpodidentitybinding.-generatedyaml
kubectl apply -f ./app/keyvault/keyvault-generated.yaml
deleteFile $DIR_APPS/keyvault/keyvault-generated.yaml
deleteFile $DIR_APPS/keyvault/aadpodidentitybinding-generated.yaml
echo -e '\e[96mKeyVault app installed\e[0m'

echo 'Installing event application'

# cp ./app/keda/event-source.yaml ./app/keda/event.yaml # create a copy to replace variables in
eventAppNs=event-app
kubectl delete ns $eventAppNs --ignore-not-found
az servicebus namespace create --name $appEventSbName --resource-group $resourceGroup  --location $location --sku basic
az servicebus queue create --resource-group $resourceGroup --namespace-name $appEventSbName --name orders
az servicebus queue authorization-rule create --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name reader-rule --rights Manage Send Listen
az servicebus queue authorization-rule create --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name writer-rule --rights Manage Send Listen
export eventSbReaderConnectionString="$(az servicebus queue authorization-rule keys list --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name reader-rule --query primaryConnectionString -o tsv)"
echo $eventSbReaderConnectionString
export eventSbReaderConnectionStringBase64="$(echo -ne "$eventSbReaderConnectionString" | base64 -w 0)";
export eventSbWriterConnectionString="$(az servicebus queue authorization-rule keys list --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name writer-rule --query primaryConnectionString -o tsv)"
echo $eventSbWriterConnectionString
export eventSbWriterConnectionStringBase64="$(echo -ne "$eventSbWriterConnectionString" | base64 -w 0)";
# sed -i "s/CONNECTION_STRING_TOKEN/$eventSbReaderConnectionStringBase64/g" $DIR_APPS/keda/event.yaml
# sed -i "s/CONNECTION_STRING_MANAGEMENT_TOKEN/$eventSbWriterConnectionStringBase64/g" $DIR_APPS/keda/event.yaml
envsubst < $DIR/keda/event-source.yaml > $DIR/keda/event-generated.yaml
kubectl apply -f $DIR_APPS/keda/event-generated.yaml -n $eventAppNs
deleteFile $DIR_APPS/keda/event-generated.yaml

echo -e '\e[96mEvent app installed\e[0m'

echo 'Waiting 120 sec to let public IP getting generated'

sleep 120
helloWorldIP="$(kubectl get svc hello-world-svc -n hello-world -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
netpolIP="$(kubectl get svc front-end-svc -n netpol -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
eventAppIP="$(kubectl get svc order-web-svc -n $eventAppNs -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
echo -e "Hello-world accessible here: \e[96m http://$helloWorldIP \e[0m" 
echo -e "Event-app accessible here: \e[96m http://$eventAppIP \e[0m" 
echo -e "NetPol accessible here: \e[96m http://$netpolIP \e[0m" 
