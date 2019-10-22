#!/usr/bin/env bash

ansible-playbook -u $1 --ask-pass --ask-become-pass --tags "jupyterhub_whole_install" --extra-vars "@./vars.yaml" main.yml -vvvv