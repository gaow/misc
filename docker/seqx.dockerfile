# Docker container for SEQPower and SEQLinkage

# Pull base image
FROM gaow/debian-py2:latest

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /tmp
ADD http://bioinformatics.org/spower/download/.private/cstatgen.tar.gz ./
ADD https://github.com/gaow/SEQPower/archive/master.zip spower-master.zip
ADD https://github.com/gaow/SEQLinkage/archive/master.zip seqlink-master.zip
RUN pip install brewer2mpl==1.4.1 prettyplotlib==0.1.7 pysqlite==2.8.3 statsmodels
RUN R --slave -e "install.packages('http://cran.r-project.org/src/contrib/Archive/SKAT/SKAT_0.93.tar.gz', repos=NULL, type='source'); \
    install.packages('http://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_0.9.3.1.tar.gz', repos=NULL, type='source')"
RUN tar zxf cstatgen.tar.gz && python setup.py install
RUN unzip spower-master.zip && cd SEQPower-master && \
    python setup.py install && cd data && unzip SCORE-Seq.zip && \
    chmod +x SCORE-SeqTDS SCORE-Seq && mv SCORE-SeqTDS SCORE-Seq /opt/miniconda2/bin
RUN unzip seqlink-master.zip && cd SEQLinkage-master && \
    python setup.py install && cd data && \
    tar jxf SEQLinkageResources.tar.bz2 -C /
RUN rm -rf *

# Default command
CMD ["bash"]
