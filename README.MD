zshk8s
=====

Utility docker environment which contains dotnet, rust, nvm (node version manager), cheatsheet, and so on (check the dockerfile for full details).


Usage - Running
----

In 'run.sh' in this repo we find sample shell script to get the full feature set

    #!/bin/bash
    docker container run \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.ssh:/root/.ssh \
        -v ~/.kube/:/root/.kube \
        -v ~/source:/root/source \
        -it robchartier/zshk8s

Volumes:
----
	-v /var/run/docker.sock:/var/run/docker.sock \

Gain access to manage the host's docker environment

    -v ~/.ssh:/root/.ssh

Mount your host's ssh folder so the docker client has access to all your docker setup

    -v ~/.kube/:/root/.kube

Mount your kubeconfigs

    -v ~/source:/root/source

Mount your root folder for all your source projects



Usage - Building
----
After editing the Dockerfile, or any of the other environment specific files, just run 'build.sh'.  


Usage - Publishing
----
Once build, publish to docker hub with 'publish.sh'



