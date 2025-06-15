DOMAIN=$(jq -r '.Domain' ../../config.json)
curl https://$DOMAIN/server/authentication/logoff.php -b ../../cookies.txt -c ../../cookies.txt -s
rm -f ../../credentials.txt