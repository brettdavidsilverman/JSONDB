# JSONDB
LAMP JSON Database

Stores, updates and searches JSON data
stored in a MySQL database using
php and apache.

# for server scripts
sudo apt install jq

# Instructions to setup email

install postfix

edit /etc/postfix/main.cf
   relayhost = [smtp.gmail.com]:587
   smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt 
   
create google app password

edit /etc/postfix/sasl_passwd
   [smtp.gmail.com]:587 email@gmail.com:{app password}
   
sudo postmap /etc/postfix/sasl_passwd
sudo chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
sudo chmod 0600 /etc/postfix/sasl_passwd
 
sudo service postfix restart
