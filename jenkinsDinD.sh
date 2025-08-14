#!/bin/bash

#this script creates a jenkins container with access to the docker daimen
#threw the docker.sock, works when runing as root, unsafe use only for testing

yum install -y git docker java-17-amazon-corretto-devel

systemctl start docker

DOCKER_GID=$(stat -c '%g' /var/run/docker.sock 2>/dev/null || stat -f '%g' /var/run/docker.sock)

docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --group-add ${DOCKER_GID} -e DOCKER_HOST=unix:///var/run/docker.sock -e DOCKER_TLS_VERIFY= -e DOCKER_CERT_PATH= jenkins/jenkins:lts-jdk17

docker exec -u root -it jenkins bash -lc "apt-get update && apt-get install -y docker.io"

docker exec -it jenkins docker run --rm hello-world

#for the jenkins password

docker logs jenkins
