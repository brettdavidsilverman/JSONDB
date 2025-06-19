./authenticate.sh
if [[ $? != 0 ]]
then
    echo "😢"
    exit 1
fi;

DOMAIN=$(jq -r '.Domain' ../../config.json)
    
echo ""
date
curl -s "https://${DOMAIN}/my" -b ../../cookies.txt -c ../../cookies.txt --data "@../large.json" &

UPLOAD_PID=$!

# do other stuff

DONE=false

while [ "${DONE}" == "false" ]
do
   
   STATUS=$(./getsessionstatus.sh)
   PERCENTAGE=$(echo "${STATUS}" | jq '.percentage');
   echo "${PERCENTAGE}"
   DONE=$(echo "${STATUS}" | jq '.done')

   sleep 5
      
done

./getsessionstatus.sh

echo ""