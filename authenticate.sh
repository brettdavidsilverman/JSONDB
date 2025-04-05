curl https://bee.fish/server/authentication/authenticate.php -b ../cookies.txt -c ../cookies.txt -s -o /dev/null -w "%{http_code}" 
