#!/bin/bash

# Nginx installation
sudo apt update -y && sudo apt install nginx -y && -y sudo ufw allow 'Nginx HTTP' && systemctl start nginx && systemctl enable nginx
os=`cat /etc/os-release`
mem=`free -h`
echo "
<!DOCTYPE html><html><head><title>Task3</title></head><body><h1><strong>Hello World!</strong></h1><div><p>$os</p><br><h4>Memory</h4><p>$mem</p></div></body></html>" > /var/www/html/index.html

# Docker installation
sudo apt-get install docker-ce docker-ce-cli containerd.io -y && systemctl start docker && systemctl enable docker
