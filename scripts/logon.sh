SECRET=$(cat $2  | openssl dgst -binary -sha512 | base64)
CREDENTIALS='{"email":"'$1'", "secret":"'${SECRET}'"}'
DOMAIN=$(jq -r '.Domain' ../../config.json)
LOGGEDON=$(echo "$CREDENTIALS" | curl "https://${DOMAIN}/server/authentication/logon.php" -b ../../cookies.txt -c ../../cookies.txt -s -d@-)
    
if [[ $LOGGEDON == "true" ]]
then
    echo "Logged on as $1"
    exit 0
else
    echo "Invalid credentials"
    exit 1
fi
