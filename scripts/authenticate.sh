DOMAIN=$(jq -r '.Domain' ../../config.json)
curl https://$DOMAIN/server/authentication/authenticate.php -b ../../cookies.txt -c ../../cookies.txt -s -o /dev/null -w "%{http_code}" 
