#!/bin/bash
# docker container run -ti robchartier/zshk8s
docker container run \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ~/.ssh:/root/.ssh \
	-v ~/.kube/:/root/.kube \
	-v ~/source:/root/source \
	-it robchartier/zshk8s
