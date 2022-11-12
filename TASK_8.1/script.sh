#!/bin/bash
docker run --rm -i --name centos7 -d centos:7
docker run --rm -i --name ubuntu -d evgenilistopad/ubuntu:python3 
docker run --rm -i --name fedora -d fedora:38
docker ps
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file vault_pass.txt
docker stop centos7
echo "is stopped"
docker stop ubuntu
echo "is stopped"
docker stop fedora
echo "is stopped"
