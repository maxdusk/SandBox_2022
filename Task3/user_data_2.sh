#!/bin/bash
# SSH key add
echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
echo 'AuthorizedKeysFile      .ssh/authorized_keys' >> /etc/ssh/sshd_config
systemctl reload sshd

# Nginx installation
apt update -y && apt install nginx -y && -y sudo ufw allow 'Nginx HTTP' && systemctl start nginx && systemctl enable nginx
os=`cat /etc/os-release`
mem=`free -h`
# Docker installation
apt-get update

apt-get install \
ca-certificates \
curl \
gnupg \
lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y && systemctl start docker && systemctl enable docker

docker=`docker --version`

echo "
<!DOCTYPE html><html><head><title>Task3</title></head><body><h1><strong>Hello World!</strong></h1><div><p>$os</p><br><h4>Memory</h4><p>$mem</p><br><p>$docker is Installed</p></div></body></html>" > /var/www/html/index.html
