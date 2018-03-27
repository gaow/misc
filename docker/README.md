To create and push a docker image to dockerhub.com:

```
docker build - < Dockerfile
docker images
docker tag <image_hash> <user>/<repo>:tag # docker tag f581da4aea26 gaow/debian-ngs:latest
docker push <user>/<repo>
```
To run a docker image:

```
docker run --rm --security-opt label:disable -v ${HOME%%/${USER}}:/home -v /tmp:/tmp -t -P -w $PWD -u $UID:${GROUPS[0]} \
  <user>/<repo> <command>
```
