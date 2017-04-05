sudo apt-get -y update

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



echo "setting up rs config..." 
sudo cat <<EOT >> /var/www/resourcespace/include
<?php
###############################
## ResourceSpace
## Local Configuration Script
###############################

# All custom settings should be entered in this file.
# Options may be copied from config.default.php and configured here.

# MySQL database settings
$mysql_server = 'localhost';
$mysql_username = 'root';
$mysql_password = 'rootpass1234';
$mysql_db = 'resourcespace';

$mysql_bin_path = '/usr/bin';

# Email settings
$email_notify = 'rogerhoward@gmail.com';
$email_from = 'rogerhoward@gmail.com';
# Secure keys
$spider_password = 'ec4e9122148efd72553a0439031821a96f0c4c4e12080b97f0744f0ae597b922';
$scramble_key = '32e4407fab079fc6708d4f6a1e9e9cef15c90611ac852a49554afeffd562d9a3';
$api_scramble_key = 'abe85dbb28e0fae45367b7ede669b6f2c43fbc92a83ef29898f7df13da89e64e';

# Paths
$imagemagick_path = '/usr/bin';
$ghostscript_path = '/usr/bin';
$ffmpeg_path = '/usr/bin';
$exiftool_path = '/usr/bin';
$antiword_path = '/usr/bin';
$pdftotext_path = '/usr/bin';

$enable_remote_apis = true;
$defaultlanguage = 'en-US';

#Design Changes
$slimheader=true;


$baseurl = "http://dam.local:8181"
/*

New Installation Defaults
-------------------------

The following configuration options are set for new installations only.
This provides a mechanism for enabling new features for new installations without affecting existing installations (as would occur with changes to config.default.php)

*/
                                
// Set imagemagick default for new installs to expect the newer version with the sRGB bug fixed.
$imagemagick_colorspace = "sRGB";

// No "contact us" link for new installations
$contact_link=false;

$slideshow_big=true;
$home_slideshow_width=1400;
$home_slideshow_height=900;

$homeanim_folder = 'filestore/system/slideshow';


$themes_simple_view=true;
$themes_category_split_pages=true;
$theme_category_levels=8;

$simple_search_pills_view = true;

$stemming=true;
EOT