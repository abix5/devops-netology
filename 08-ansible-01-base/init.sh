#!/usr/local/env bash
docker-compose up -d
ansible-playbook playbook/site.yml -i playbook/inventory/prod.yml --vault-password-file playbook/pass.txt
docker-compose down