# For susie

FROM debian:sid-slim

WORKDIR /tmp

# R related
RUN apt-get update \
    && apt-get install -y r-base r-base-dev pandoc \
    && apt-get clean
RUN apt-get update \
    && apt-get install -y libatlas3-base libssl-dev libcurl4-openssl-dev libxml2-dev curl \
    && apt-get clean
RUN R --slave -e "install.packages('pkgdown')"
RUN R --slave -e "install.packages(c('genlasso', 'glmnet'))"

# Finemapping related
RUN R --slave -e "for (p in c('dplyr', 'stringr', 'readr', 'magrittr')) if (!require(p, character.only=TRUE)) install.packages(p)"

RUN apt-get update \
    && apt-get install -y libgsl-dev libboost-iostreams-dev \
    && apt-get clean

RUN git clone https://github.com/fhormoz/caviar.git && cd caviar/CAVIAR-C++ && make \
    && mv CAVIAR eCAVIAR mupCAVIAR setCAVIAR /usr/local/bin && rm -rf /tmp/*

RUN git clone https://github.com/xqwen/dap.git && cd dap/dap_src && make && mv dap-g /usr/local/bin && rm -rf /tmp/*

RUN curl -L http://www.christianbenner.com/finemap_v1.1_x86_64.tgz -o finemap.tgz \
    && tar zxvf finemap.tgz && mv finemap_v1.1_x86_64/finemap_v1.1_x86_64 /usr/local/bin/finemap \
    && chmod +x /usr/local/bin/finemap && rm -rf /tmp/*

# DSC related
RUN apt-get update \
    && apt-get install -y python3-pip \
    && apt-get clean

RUN pip3 install sos sos-notebook dsc rpy2==2.9.4 tzlocal --no-cache-dir
RUN R --slave -e "devtools::install_github('stephenslab/dsc',subdir = 'dscrutils')"

# Supporting files
RUN curl -L https://raw.githubusercontent.com/stephenslab/susieR/master/inst/code/finemap.R -o /usr/local/bin/finemap.R \
    && chmod +x /usr/local/bin/finemap.R

RUN curl -L https://raw.githubusercontent.com/stephenslab/susieR/master/inst/code/caviar.R -o /usr/local/bin/caviar.R \
    && chmod +x /usr/local/bin/caviar.R

RUN curl -L https://raw.githubusercontent.com/stephenslab/susieR/master/inst/code/dap-g.py -o /usr/local/bin/dap-g.py \
    && chmod +x /usr/local/bin/dap-g.py

# susieR update
RUN R --slave -e "devtools::install_github('stephenslab/susieR')"

ENV R_ENVIRON_USER ""
ENV R_PROFILE_USER ""

CMD ["bash"]

# Usage

# 1. Create `docker-susie` alias:
# alias docker-susie="docker run --rm --security-opt label:disable -t -h susie -P -w $PWD -v $PWD:$PWD -u $UID:${GROUPS[0]} -e HOME=/home/$USER -e USER=$USER gaow/susie"

# 2. To run and build `susieR` vignettes:
# docker-susie R --slave -e "pkgdown::build_site()"