FROM debian:stable-slim

WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y libatlas3-base r-base r-base-dev unzip curl ca-certificates \
    && apt-get clean
RUN curl -L https://github.com/stephenslab/susieR/archive/master.zip -o susie.zip \
	&& unzip susie.zip && cd susieR-master && R CMD build . && R CMD INSTALL susieR_*.tar.gz \
	&& rm -rf /tmp/*
RUN curl -L https://github.com/stephenslab/susieR/files/1992536/susie_issue6.tar.gz -o susie_issue6.tar.gz \
	&& tar zxvf susie_issue6.tar.gz && mv susie_issue6.rds /opt && rm -rf /tmp/*

CMD ["bash"]

# to run the test:
# docker run --rm gaow/susie Rscript -e "attach(readRDS('/opt/susie_issue6.rds')); res = susieR::susie(X,Y); print(names(res)); print(sessionInfo())"
