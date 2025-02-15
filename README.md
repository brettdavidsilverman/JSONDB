# JSONDB
LAMP JSON Database

install postfix

edit /etc/postfix/main.cf
   relayhost = [smtp.gmail.com]:587
   smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt 
   
create google app password

edit /etc/postfix/sasl_passwd
   [smtp.gmail.com]:587 noreply.bee.fish@gmail.com:<app password>
   
sudo postmap /etc/postfix/sasl_passwd
sudo chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
sudo chmod 0600 /etc/postfix/sasl_passwd
 
sudo service postfix restart