#!/bin/bash
sudo apt-get update -y
sudo apt-get install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
cat <<HTML > /var/www/html/index.html
${file("portfolio.html")}
HTML
