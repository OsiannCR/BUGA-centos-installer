#!/bin/bash

# PHP-SSH2 Installer in Centos Web Panel

# Simple Bash script by Bullten Web Hosting Solutions [http://www.bullten.com]

CDIR='/usr/local/ssh2'
CDIRJP='/usr/local/jp'
PATHPHP='/usr/local/php/php.ini'
SOURCE_URL_1='http://www.libssh2.org/download/libssh2-1.5.0.tar.gz'
SOURCE_URL_2='https://pecl.php.net/get/ssh2-0.12.tgz'
packagelibssh="libssh2-1.5.0.tar.gz"
packagessh="ssh2-0.12.tgz"
RED='\033[01;31m'
RESET='\033[0m'
GREEN='\033[01;32m'


clear

echo -e "$GREEN******************************************************************************$RESET"
echo -e "   BUGA Installation in CentOS 7 $RESET"
echo -e "       by Osiann/JP"
echo -e "   Test version   "
echo -e "$GREEN******************************************************************************$RESET"
echo " "
echo " "
echo -e $RED"This script will install requirements on your system"$RESET
echo -e $RED""
echo -n  "Press ENTER to start the installation  ...."
read option

clear

echo ""
echo -e $RED"Update your system"$RESET
sleep 5

yum update -Y
echo ""
echo -e $RED"Yum Update"$RESET
sleep 5

clear

echo ""
echo -e $RED"Installing HTTPD on your system"$RESET
sleep 5

yum install httpd -Y
systemctl start httpd.service
systemctl enable httpd.service
echo ""
echo -e $RED"HTTPD installed on your system"$RESET
sleep 5

clear

echo ""
echo -e $RED"Installing MARIADB-MYSQL on your system"$RESET
sleep 5

yum install mariadb-server mariadb -Y
systemctl start mariadb
systemctl enable mariadb.service
echo ""
echo -e $RED"MARIADB-MYSQL installed on your system"$RESET
sleep 5

clear

echo ""
echo -e $RED"Installing php 5.6 on your system"$RESET
sleep 5

rm -rf $CDIRJP; mkdir $CDIRJP

cd $CDIRJP
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -Y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -Y
yum install yum-utils -Y
yum-config-manager --enable remi-php56
yum-config-manager --enable remi-php56
yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -Y
systemctl restart httpd.service
php -v

echo ""
echo -e $RED"PHP 5.6 installed on your system"$RESET
sleep 5

clear

echo ""
echo -e $RED"Installing libssh2 on your system"$RESET
sleep 5

rm -rf $CDIR; mkdir $CDIR

cd $CDIR
wget $SOURCE_URL_1
tar zxvf $packagelibssh
cd libssh2-1.5.0
./configure --enable-shared --with-gnu-ld
make && make install

echo ""
echo -e $RED"libssh2 installed on your system"$RESET
sleep 5

clear

echo ""
echo -e $RED"Installing ssh2 on your system"$RESET
sleep 5

cd $CDIR
wget $SOURCE_URL_2
tar zxvf $packagessh
cd ssh2-0.12
phpize
./configure --with-ssh2
make && make install

echo ""
echo -e $RED"ssh2 installed on your system"$RESET
sleep 5

clear

echo ""
echo -e $RED"Enabling php extension for ssh2"$RESET
sleep 5

if [ -e "/usr/local/php/php.ini" ];then

sed -i '/extension=ssh2.so/d' $PATHPHP
echo "extension=ssh2.so" >> $PATHPHP
echo -e $RED"PHP-SSH2 installation completed."$RESET

else

echo ""
echo -e $RED"php.ini doesnt exist / Installation failed."$RESET

fi

echo ""
echo -e $RED"Restarting Apache"$RESET

service httpd restart

sleep 2

echo ""
echo -e $RED"Checking installation"$RESET
php -i | grep ssh2