#!/bin/bash
set -e

echo "🔹 Updating system..."
sudo apt update -y
sudo apt upgrade -y

echo "🔹 Installing Apache and PHP..."
sudo apt install -y apache2 php-cli libapache2-mod-php

echo "🔹 Configuring Apache..."
# Apache يسمع على كل الواجهات
sudo sed -i 's/Listen 80/Listen 0.0.0.0:80/' /etc/apache2/ports.conf

# تجاوز التحذير ServerName
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
sudo a2enconf fqdn

echo "🔹 Restarting Apache..."
sudo service apache2 restart

echo "🔹 Setting up project folder..."
# لو عندك ملفات موجودة في workspace خليها جاهزة في /var/www/html
PROJECT_DIR="/workspaces/Lindind"
sudo rm -rf /var/www/html/*
sudo cp -r $PROJECT_DIR/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html

echo "🔹 Starting PHP built-in server for testing (optional)..."
# لو حابب تشغيل PHP built-in server بدل Apache
# php -S 0.0.0.0:8000 -t /var/www/html &

echo "✅ All done! Your Apache + PHP environment is ready."
