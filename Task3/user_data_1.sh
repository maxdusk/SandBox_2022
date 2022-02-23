#!/bin/bash

#Nginx installation
yum update -y && yum install nginx -y && systemctl start nginx && systemctl enable nginx && systemctl status nginx
echo '
<!DOCTYPE html><html><head><title>Task3</title></head><body><h1><strong>Hello World!</strong></h1></body></html>' > /usr/share/nginx/html/index.html
