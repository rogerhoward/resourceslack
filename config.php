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


$baseurl = "http://0.0.0.0:8181/"
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
