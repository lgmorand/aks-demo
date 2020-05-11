spnPassword="$(az ad sp create-for-rbac --name $aksSpn --skip-assignment --query password -o tsv)"
echo "SPN created, waiting 30sec to properly sync"
sleep 30

spnAppId="$(az ad sp show --id $aksSpn --query appId  -o tsv)"

echo -e "Service Principal created is : \e[96m" $aksSpn  "\e[0m"
echo -e "AppId : \e[96m" $spnAppId  "\e[0m"
echo -e "Password: \e[96m" $spnPassword  "\e[0m"
