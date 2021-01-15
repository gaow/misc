# openconnect and openssh-client

FROM debian:stable-slim
WORKDIR /tmp
RUN apt-get update -y \
    && apt-get install -qq -y --no-install-recommends \
	ca-certificates openconnect openssh-client \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log
# Default command
CMD ["bash"]

# To run it:
# docker run -d --rm --security-opt label:disable --privileged -t --name openconnect gaow/openconnect
# Then login:
# docker exec -it openconnect bash
