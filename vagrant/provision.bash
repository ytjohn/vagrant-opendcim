#!/bin/bash

# set mysql root password to 'root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

sudo apt update
sudo apt -y install apache2 libapache2-mod-php  \
   mysql-server php-fpm php-mysql \
   php-snmp snmp-mibs-downloader php-curl php-gettext graphviz php-mbstring

# download and extract openDCIM
if [ ! -d /vagrant/openDCIM-4.3.1 ]
then

    if [ ! -f /vagrant/openDCIM-4.3.1.tar.gz ]; then
        echo "Fetching opendcim-4.3.1"
        wget http://www.opendcim.org/packages/openDCIM-4.3.1.tar.gz -O /vagrant/openDCIM-4.3.1.tar.gz
    fi

    cd /vagrant
    tar -xzf openDCIM-4.3.1.tar.gz

fi

if [ ! -L /vagrant/dcim ]; then
    ln -s /vagrant/openDCIM-4.3.1 /vagrant/dcim
fi


# apache steps
sudo chgrp -R www-data /vagrant/dcim/pictures /vagrant/dcim/drawings
sudo a2enmod authn_file authn_core authz_user auth_basic
sudo a2enmod rewrite

sudo cp /vagrant/vagrant/000-default.conf /etc/apache2/sites-available/
sudo service apache2 restart

# mysql step
sudo cp /vagrant/vagrant/nostrict.cnf /etc/mysql/conf.d
sudo service mysql restart

mysql -u root -proot -e "CREATE DATABASE dcim;"
mysql -uroot -proot -e "CREATE USER 'dcim'@'localhost' IDENTIFIED BY 'dcim'"
mysql -uroot -proot -e "GRANT ALL ON dcim.* TO 'dcim'@'localhost';"
cp /vagrant/dcim/db.inc.php-dist /vagrant/dcim/db.inc.php
