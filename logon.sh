SECRET=$(cat ../logon.jpg  | openssl dgst -binary -sha512 | base64)
CREDENTIALS="{\"email\":\"brettdavidsilverman@gmail.com\",\"secret\":\"${SECRET}\"}"
echo "${CREDENTIALS}" > ../credentials.txt
curl https://bee.fish/server/authentication/logon.php -b ../cookies.txt -c ../cookies.txt --data "@../credentials.txt" -s
rm ../credentials.txt