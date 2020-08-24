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

# Create backup of /etc/apache2/apache2.conf
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak

# Move default apache root directory 'www' to '~/Projects/www'
if ! sudo grep -q "<Directory /home/$(id -un)/Projects/www>" /etc/apache2/apache2.conf; then
  # Update default apache root directory only if not already
  sudo sed -i \
  "\$i<Directory /home/$(id -un)/Projects/www>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>\n" \
  "/etc/apache2/apache2.conf"

  execlog "cp -r /var/www ${HOME}/Projects"
  execlog "mkdir -p ${HOME}/Projects/www/default"

  # Replace DocumentRoot in /etc/apache2/sites-enabled/000-default.conf only if not already
  if ! sudo grep -qF "# DocumentRoot /var/www/html" /etc/apache2/sites-enabled/000-default.conf; then
    sudo sed -i \
      "s,DocumentRoot /var/www/html,# DocumentRoot /var/www/html\n\tDocumentRoot /home/$(id -un)/Projects/www/default," \
      "/etc/apache2/sites-enabled/000-default.conf"
  fi

  # Create default apache homepage
  echo "<h1>This is Apache2 default site</h1>" > ~/Projects/www/default/index.html
  sudo service apache2 restart
fi

# MySQL
if apt_install "mysql-server" && apt_install "mysql-client" -y; then
  echolog
  warning "################################################################################"
  warning "# DO NOT install MySQL VALIDATE PASSWORD COMPONENT for phpmyadmin installation #"
  warning "################################################################################"
  echolog
  sudo service mysql start && sudo mysql_secure_installation
fi

# PHP
if apt_bulk_install "${APT_PACKAGES_SERVER_PHP_DEPENDENCIES[@]}"; then
  # Create default php homepage
  echo '<?php\nphpinfo();\n?>' > ~/Projects/www/default/info.php
fi

# PhpMyAdmin
if sudo service mysql start; then # its IMPORTANT that mysql is running before installing
  apt_install phpmyadmin
fi

