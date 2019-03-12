#!/bin/bash

# PHP-SSH2 Installer in Centos Web Panel

# Simple Bash script by Bullten Web Hosting Solutions [http://www.bullten.com]

CDIR='/usr/local/ssh2'
CDIRJP='/usr/local/jp'
PATHPHP='/usr/local/php/php.ini'
PATHPHP2='/etc/php.ini'
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
echo -e "       by Osiann/JP version 1.0"
echo -e "   Test version   "
echo -e "$GREEN******************************************************************************$RESET"
echo " "
echo " "
echo -e $GREEN"This script will install requirements on your system"$RESET
echo -e $GREEN""
echo -n  "Press ENTER to start the installation  ...."
read option

clear

echo -e $RED"This script will install requirements on your system"$RESET
echo -e $RED""
echo -e  $RED"Are you sure "$GREEN"Herbert"$RED"? press ENTER if you're sure  ...."
read option

clear

echo ""
echo -e $RED"Update your system"$RESET
sleep 3

yum update -y
echo ""
echo -e $RED"Yum Update"$RESET
sleep 3

clear

echo ""
echo -e $RED"install simple tools"$RESET
sleep 5
echo -e $RED"install WGET"$RESET
sleep 2
yum install wget -y
clear
echo -e $RED"install UNZIP"$RESET
sleep 2
yum install unzip -y
clear
echo -e $RED"install NANO"$RESET
sleep 2
yum install nano -y
clear
echo -e $RED"install SCREEN"$RESET
sleep 2
yum install screen -y
clear
echo -e $RED"install HTOP"$RESET
sleep 2
yum install htop -y
clear
echo -e $RED"install SSHPASS"$RESET
sleep 2
yum install sshpass -y
clear
echo -e $RED"install GCC"$RESET
sleep 2
yum install gcc -y
clear
echo -e $RED"install CMAKE"$RESET
sleep 2
yum install cmake -y
clear
echo -e $RED"install OPENSSL"$RESET
sleep 2
yum install openssl-devel -y
clear
echo ""
echo -e $RED"tools installed"$RESET
sleep 5

clear

echo ""
echo -e $RED"Installing HTTPD on your system"$RESET
sleep 5

yum install httpd -y
systemctl start httpd.service
systemctl enable httpd.service
echo ""
echo -e $RED"HTTPD installed on your system"$RESET
sleep 5

clear

echo ""
echo -e $RED"Installing MARIADB-MYSQL on your system"$RESET
sleep 5

yum install mariadb-server mariadb -y
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
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php56
yum-config-manager --enable remi-php56
yum install php php-devel php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -y
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
echo "date.timezone = 'America/New_York'" >> $PATHPHP
echo -e $RED"PHP-SSH2 installation completed."$RESET

elif [ -e "/etc/php.ini" ];then

sed -i '/extension=ssh2.so/d' $PATHPHP2
echo "extension=ssh2.so" >> $PATHPHP2
echo "date.timezone = 'America/New_York'" >> $PATHPHP2
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
php --version
