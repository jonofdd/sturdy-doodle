#!/bin/bash
cd /root/ci-cd
docker stack deploy -c docker-stack.yml hello-world-stack