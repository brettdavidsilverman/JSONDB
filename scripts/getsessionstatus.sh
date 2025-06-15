DOMAIN=$(jq -r '.Domain' ../../config.json)
curl https://$DOMAIN/server/getSessionStatus.php -b ../../cookies.txt -c ../../cookies.txt
