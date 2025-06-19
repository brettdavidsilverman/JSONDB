# JSONDB
LAMP JSON Database

Stores, updates and searches JSON data
stored in a MySQL database using
php and apache.

install mysql
install apache2

Create config.json in JSONDB parent directory.
Theres a sample <a href="config.json">config.json</a>


# install JSONDB database
sudo apt install jq
./createdatabase.sh
./updateprocedures.sh

# Instructions to setup google email

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
