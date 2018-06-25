# For Kushal's `isee`

FROM debian:stable-slim

WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y libatlas3-base r-base r-base-dev unzip curl ca-certificates \
    && apt-get clean
RUN curl -L http://bcf.usc.edu/~jinchilv/publications/software/isee.zip \
	&& unzip isee.zip && mv isee/slasso.so /usr/local/lib && rm -rf /tmp/*

CMD ["bash"]

# to use it:

# 1. set an alias:
# alias isee-docker='docker run --rm --security-opt label:disable -t '\
'-P -h MASH -w $PWD -v $HOME:/home/$USER -v /tmp:/tmp -v $PWD:$PWD '\
'-u $UID:${GROUPS[0]} -e HOME=/home/$USER -e USER=$USER gaow/isee-lv'

# 2. edit `isee_all.R` replacing `slasso.so` with `/usr/local/lib/slasso.so`
# 3. Run:
# isee-docker Rscript -e "source('isee_all.R'); source('example.R')"
