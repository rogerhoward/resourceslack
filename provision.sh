sudo apt-get -y update
sudo apt-get -y install avahi-utils
echo "installing mysql..." 
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password rootpass1234'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password rootpass1234'
sudo apt-get -y install mysql-server
mysql -u root -prootpass1234 -e "create database resourcespace;"

echo "installing other packages..." 
sudo apt-get -y install apache2 php7.0 php7.0-dev php7.0-gd php7.0-mysql php-mbstring php-zip libapache2-mod-php subversion
sudo apt-get -y install nano imagemagick git
sudo apt-get -y install ghostscript antiword xpdf libav-tools libimage-exiftool-perl cron wget


echo "setting up resourcespace base..." 
cd /var/www 
sudo mkdir -p resourcespace && cd resourcespace 
sudo svn co http://svn.resourcespace.com/svn/rs/releases/8.1 .
sudo mkdir -p filestore 
sudo chmod -R 777 filestore
sudo mkdir -p ./plugins/slack
sudo chmod -R 777 include


echo "setting up cron job..." 
sudo cat <<EOT >> /etc/cron.daily/resourcespace
#!/bin/sh
wget -q -r http://localhost/pages/tools/cron_copy_hitcount.php
EOT


echo "setting up apache config..." 
sudo cat <<EOT >> /etc/apache2/sites-available/resourcespace.conf
<VirtualHost *:80>
	ServerName vagrant.local

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/resourcespace

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>
EOT

sudo rm -fR /etc/apache2/sites-enabled/*
sudo ln -s /etc/apache2/sites-available/resourcespace.conf /etc/apache2/sites-enabled/resourcespace.conf

sudo service apache2 restart
