#!/bin/bash
# create a repository to store the docker image in docker hub

# launch an ec2 instance. open port 80 and port 22

# install and configure docker on the ec2 instance
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
# docker info

# create a dockerfile
# sudo vi Dockerfile 

# build the docker image
sudo docker build . -t wordpress:latest

# use the docker tag command to give the image a new name
sudo docker tag wordpress:latest surajdev5/wordpress:latest


# login to your docker hub account
cat ~/password.txt | sudo docker login --username surajdev5 --password-stdin

# push the image to your docker hub repository
docker push surajdev5/wordpress:latest

# start the container to test the image 
docker run -dp 80:80 surajdev5/wordpress:latest

