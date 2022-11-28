#!/bin/bash
docker login
#docker run  --name zshk8s_export robchartier/zshk8s
#docker export zshk8s_export | docker import - robchartier/zshk8s:latest
docker push robchartier/zshk8s
