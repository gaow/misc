To create and push a docker image to dockerhub.com:

```
docker build - < Dockerfile
docker images
docker tag <image_hash> <user>/<repo>:tag # docker tag f581da4aea26 gaow/debian-ngs:latest
docker push <user>/repo
```
