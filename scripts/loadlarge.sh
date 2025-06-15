LOGGEDON=$(./logon.sh)
    
if [ "${LOGGEDON}" == "false" ]
then
   echo "Invalid credentials"
   exit 1
fi

DOMAIN=$(jq -r '.Domain' ../../config.json)
    
echo ""
date
curl -s https://$DOMAIN/my -b ../../cookies.txt -c ../../cookies.txt --data "@../large.json" &

UPLOAD_PID=$!

# do other stuff

RUNNING=true
while [ "${RUNNING}" == "true" ]; do
   
   if ps -p $UPLOAD_PID > /dev/null
   then
      ./getsessionstatus.sh
      echo ""
      sleep 5
   else
      RUNNING=false
   fi
done

./getsessionstatus.sh

echo ""

./logoff.sh