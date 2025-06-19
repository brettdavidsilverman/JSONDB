DOMAIN=$(jq -r '.Domain' ../../config.json)
STATUS=$(curl "https://${DOMAIN}/server/getSessionStatus.php" -s -b ../../cookies.txt -c ../../cookies.txt)
    
echo "${STATUS}"
