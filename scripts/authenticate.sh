DOMAIN=$(jq -r '.Domain' ../../config.json)
CREDENTIALS=$(curl "https://${DOMAIN}/server/authentication/authenticate.php" -b  ../../cookies.txt -c ../../cookies.txt -s)
    
if [[ "$CREDENTIALS" == "" ]]
then
    echo "Not logged in"
    exit 1
else
    EMAIL=$(echo "$CREDENTIALS" | jq -r '.email')
    echo "Logged in as $EMAIL"
    exit 0
fi