
echo 'Installing hello world application'
kubectl delete ns hello-world --ignore-not-found
kubectl apply -f ./app/hello-world
echo '\e[96mHello world app installed\e[0m'


echo 'Installing netpol application'
kubectl delete ns netpol --ignore-not-found
kubectl apply -f ./app/netpol
echo '\e[96mnetpol app installed\e[0m'

echo 'Installing monitor application'
kubectl delete ns monitor --ignore-not-found
kubectl apply -f ./app/monitor
echo '\e[96mmonitor app installed\e[0m'

echo 'Installing event application'
cp ./app/event/event.yaml ./app/event/event-copy.yaml # create a copy
eventAppNs=event-app
kubectl delete ns $eventAppNs --ignore-not-found
az servicebus namespace create --name $appEventSbName --resource-group $resourceGroup  --location $location --sku basic
az servicebus queue create --resource-group $resourceGroup --namespace-name $appEventSbName --name orders
az servicebus queue authorization-rule create --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name reader-rule --rights Manage Send Listen
az servicebus queue authorization-rule create --resource-group $resourceGroup --namespace-name $appEventSbName --queue-name orders --name writer-rule --rights Manage Send Listen
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

echo '\e[96mEvent app installed\e[0m'

echo 'Waiting 60 sec to let public IP getting generated'

sleep 60
helloWorldIP="$(kubectl get svc hello-world-svc -n hello-world -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
netpolIP="$(kubectl get svc front-end-svc -n netpol -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
eventAppIP="$(kubectl get svc order-web-svc -n $eventAppNs -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
echo -e "Hello-world accessible here: \e[96m http://$helloWorldIP \e[0m" 
echo -e "Event-app accessible here: \e[96m http://$eventAppIP \e[0m" 
echo -e "NetPol accessible here: \e[96m http://$netpolIP \e[0m" 