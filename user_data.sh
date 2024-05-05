#!/bin/bash
#Transformando meu usuário em super usuário.
sudo su
#Atualizar os pacotes do sistema
yum update -y

#Instalar, iniciar e configurar a inicialização automática do docker
yum install docker -y 
systemctl start docker
systemctl enable docker

#Adicionar o usuário ec2-user ao grupo docker
usermod -aG docker ec2-user

#Instalação do docker-compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Instalar, iniciar e configurar a inicialização automática do nfs-utils
yum install nfs-utils -y
systemctl start nfs-utils
systemctl enable nfs-utils

#Criar a pasta onde o EFS vai ser montado
mkdir /efs

#Montagem e configuração da montagem automática do EFS
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-04e5f2be2336fa54c.efs.us-east-1.amazonaws.com:/ efs
echo "fs-04e5f2be2336fa54c.efs.us-east-1.amazonaws.com:/ /efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab

# Criar uma pasta para os arquivos do WordPress
mkdir /efs/wordpress

# Criar um arquivo docker-compose.yaml para configurar o WordPress
cat <<EOL > /efs/docker-compose.yaml
version: '3.8'
services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: wordpress.cbggey8s8yli.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_TABLE_CONFIG: wp_
    volumes:
      - /efs/wordpress:/var/www/html
EOL

# Inicializar o WordPress com docker-compose
docker-compose -f /efs/docker-compose.yaml up -d
