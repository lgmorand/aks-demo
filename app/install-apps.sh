
echo 'Installing hello world application'
kubectl apply -f ./app/hello-world
helloWorldIP="$(kubectl get svc hello-world-svc -n hello-world -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
echo 'Hello world app installed'

echo 'Installing event application'
cp ./app/event/event.yaml ./app/event/event-copy.yaml # create a copy
eventAppNs=event-app
kubectl delete ns $eventAppNs
az servicebus namespace create --name $appEventSbName --resource-group $resourceGroup  --location $location --sku basic
az servicebus queue create --resource-group $resourceGroup --namespace-name $appEventSbName --name orders
az servicebus queue authorization-rule create --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name reader-rule --rights Manage
az servicebus queue authorization-rule create --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name writer-rule --rights Manage
eventSbReaderConnectionString="$(az servicebus queue authorization-rule keys list --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name reader-rule --query primaryConnectionString -o tsv)"
echo $eventSbReaderConnectionString
eventSbReaderConnectionStringBase64="$(echo -ne "$eventSbReaderConnectionString" | base64 -w 0)";
echo $eventSbReaderConnectionStringBase64
eventSbWriterConnectionString="$(az servicebus queue authorization-rule keys list --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name writer-rule --query primaryConnectionString -o tsv)"
echo $eventSbWriterConnectionString
eventSbWriterConnectionStringBase64="$(echo -ne "$eventSbWriterConnectionString" | base64 -w 0)";
echo $eventSbWriterConnectionStringBase64
sed -i "s/CONNECTION_STRING_TOKEN/$eventSbReaderConnectionStringBase64/g" ./app/event/event.yaml
sed -i "s/CONNECTION_STRING_MANAGEMENT_TOKEN/$eventSbWriterConnectionStringBase64/g" ./app/event/event.yaml
kubectl apply -f ./app/event/event-copy.yaml -n $eventAppNs
eventAppIP="$(kubectl get svc order-web-svc -n hello-world -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
echo 'Event app installed'


echo -e "Hello-world accessible here: \e[96m http://$helloWorldIP \e[0m" 
echo -e "Event-app accessible here: \e[96m http://$eventAppIP \e[0m" 