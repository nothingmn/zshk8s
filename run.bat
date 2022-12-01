set SOURCE_ROOT=c:/data/source/
set KUBE_CONFIG_ROOT=%USERPROFILE%/.kube/
set AWS_CONFIG_ROOT=%USERPROFILE%/.aws/
docker container run -v /var/run/docker.sock:/var/run/docker.sock -v %USERPROFILE%/.ssh:/root/.ssh -v %KUBE_CONFIG_ROOT%:/root/.kube  -v %AWS_CONFIG_ROOT%:/root/.aws  -v %SOURCE_ROOT%:/root/source -it robchartier/zshk8s

