#!/bin/bash

if [ $# -eq 0 ]
  then
	docker container run \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v ~/.ssh:/root/.ssh \
		-v ~/.kube/:/root/.kube \
		-v ~/source:/root/source \
		-it robchartier/zshk8s

else
	docker container run \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v ~/.ssh:/root/.ssh \
		-v ~/.kube/:/root/.kube \
		-v ~/source:/root/source \
		$@ \
		-it robchartier/zshk8s


fi

