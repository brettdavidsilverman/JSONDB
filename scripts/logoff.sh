DOMAIN=$(jq -r '.Domain' ../../config.json)
LOGGEDOFF=$(curl "https://${DOMAIN}/server/authentication/logoff.php" -b ../../cookies.txt -c ../../cookies.txt -s)
if [[ "$LOGGEDOFF" == "true" ]]
then
   echo "Logged off"
fi
