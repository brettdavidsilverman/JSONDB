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
sudo mysql
create database JSONDB;
use JSONDB;
create user 'brett'@'%' identified by 'password';
grant all privileges on JSONDB.* to 'brett'@'%';
exit

./createdatabase.sh

./updateprocedures.sh

# Instructions to setup google email

Follow these instructions

https://www.linode.com/docs/guides/configure-postfix-to-send-mail-using-gmail-and-google-workspace-on-debian-or-ubuntu/


