# Docker container for stress testing

FROM debian:stretch-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install dev libraries
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    stress \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log /tmp/*

# Default command
CMD ["bash"]
