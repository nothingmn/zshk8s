#!/bin/bash
docker rmi -f robchartier/zshk8s
docker build --no-cache --rm -t robchartier/zshk8s .
docker images
