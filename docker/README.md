To create and push a docker image to dockerhub.com:

```
cat Dockerfile | docker build --no-cache -t <user>/<repo>:tag - # eg, -t gaow/debian-ngs:latest
docker images
docker push <user>/<repo>
```
To run a docker image:

```
docker run --rm --security-opt label:disable \
       -v ${HOME%%/${USER}}:/home  -v /tmp:/tmp -v $PWD:$PWD \
       -t -P -w $PWD -u $UID:${GROUPS[0]} \
       <user>/<repo> <command>
```
