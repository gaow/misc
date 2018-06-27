# For susie

FROM debian:sid-slim

WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y r-base r-base-dev pandoc \
    && apt-get clean
RUN apt-get update \
    && apt-get install -y libatlas3-base libssl-dev libcurl4-openssl-dev libxml2-dev curl \
    && apt-get clean
RUN R --slave -e "install.packages('pkgdown')"
RUN R --slave -e "devtools::install_github('stephenslab/susieR')"

ENV R_ENVIRON_USER ""
ENV R_PROFILE_USER ""

CMD ["bash"]

# To use it:
# docker run --rm --security-opt label:disable -t -P -w $PWD -v /tmp:/tmp -v $PWD:$PWD -u $UID:${GROUPS[0]} -e HOME=/home/$USER -e USER=$USER gaow/susie R --slave -e "pkgdown::build_site()"
