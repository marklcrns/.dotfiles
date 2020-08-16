#!/bin/bash

# Server Packages

APT_PACKAGES_SERVER=(
  "apache2"
  "apache2-utils"
  "sqlite3"
  "libsqlite3-dev"
  "sqlitebrowser"
)

APT_PACKAGES_SERVER_PHP_DEPENDENCIES=(
  "php"
  "libapache2-mod-php"
  "php-cli"
  "php-fpm"
  "php-json"
  "php-pdo"
  "php-mysql"
  "php-zip"
  "php-gd"
  "php-mbstring"
  "php-curl"
  "php-xml"
  "php-pear"
  "php-bcmath"
)


echolog
echolog "${UL_NC}Installing Web Server Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_SERVER[@]}"

## create backup of apache2.conf and copy www dir to ~/Projects/www
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
# Append only if not already
# Ref: https://superuser.com/a/1314183
sudo grep -q "<Directory /home/$(id -un)/Projects/www>" /etc/apache2/apache2.conf || \
  sudo sed -i "\$i<Directory /home/$(id -un)/Projects/www>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>\n" /etc/apache2/apache2.conf
  # resolve "forbidden You don't have permission to access / on this server" issue
  # Solution: https://askubuntu.com/a/738527
  # Resources:
  # https://unix.stackexchange.com/questions/26284/how-can-i-use-sed-to-replace-a-multi-line-string
  # https://stackoverflow.com/questions/11234001/replace-multiple-lines-using-sed
  # TODO: Fix. Multiple \n match does not work
  # sudo sed 'N; s/<Directory \/>\n\tOptions FollowSymLinks\n\tAllowOverride None\n\tRequire all denied/<Directory \/>\n\tOptions Indexes FollowSymLinks Includes ExecCGI\n\tAllowOverride all\n\tRequire all granted/g' \
  #  /etc/apache2/apache2.conf

  cp -r /var/www ${HOME}/Projects/
  mkdir -p ${HOME}/Projects/www/default
  # replace DocumentRoot in /etc/apache2/sites-enabled/000-default.conf
  # Modify only if not already
  sudo grep -qF "# DocumentRoot /var/www/html" /etc/apache2/sites-enabled/000-default.conf || \
    sudo sed -i "s,DocumentRoot /var/www/html,# DocumentRoot /var/www/html\n\tDocumentRoot /home/$(id -un)/Projects/www/default," \
    /etc/apache2/sites-enabled/000-default.conf
      echo "<h1>This is Apache2 default site</h1>" > ~/Projects/www/default/index.html
      sudo service apache2 restart

# MySQL
if apt_install "mysql-server" && apt_install "mysql-client" -y; then
  ## When passsword prompt:
  ## Password valdation: Low `0`
  ## Then Answer `y` for the rest of the question prompts
  sudo service mysql start && sudo mysql_secure_installation
fi

# PHP
if apt_bulk_install "${APT_PACKAGES_SERVER_PHP_DEPENDENCIES[@]}"; then
  echo '<?php\nphpinfo();\n?>' > ~/Projects/www/default/info.php
fi

# PhpMyAdmin
# Ref: https://www.fosslinux.com/6745/how-to-install-phpmyadmin-with-lamp-stack-on-ubuntu.htm
# MYSQL application password for phpmyadmin set up
if sudo service mysql start; then # its IMPORTANT that mysql is running before installing
  # PhpMyAdmin Prompt:
  # apache2
  # Yes
  apt_install phpmyadmin
fi

