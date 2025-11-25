# JSONDB
LAMP JSON Database

Stores, updates and searches JSON data
stored in a MySQL database using
php and apache.

# Install mysql

wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb
sudo dpkg -i mysql-apt-config_*_all.deb
sudo apt update
sudo apt install mysql-server
(Enter a password for root)


# install apache2
sudo apt install apache2
sudo apt install php

Create config.json in JSONDB parent directory.

Theres a sample <a href="config.json">config.json</a>


# Install JSONDB database
# create JSONDB database

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
