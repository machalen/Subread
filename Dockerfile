####################################################
#RNA-seq Tools
#Dockerfile to build a container with subread
#Ubuntu Focal
####################################################
#Build the image based on Ubuntu
FROM ubuntu:focal

#Maintainer and author
MAINTAINER Magdalena Arnal <magdalena.arnalsegura@iit.it>

#Install required libraries in ubuntu
RUN apt-get update && apt-get install --yes build-essential gcc-multilib apt-utils zlib1g-dev \
libbz2-dev git perl gzip ncurses-dev libncurses5-dev libbz2-dev \
liblzma-dev libssl-dev libcurl4-openssl-dev libgdbm-dev libnss3-dev libreadline-dev libffi-dev wget

#Install python3
RUN apt-get update && apt-get install --yes python3

#Install required libraries in ubuntu for samtools
RUN apt-get update -y && apt-get install -y unzip bzip2 g++
#Set wokingDir in /bin
WORKDIR /bin

#Install and Configure samtools
RUN wget http://github.com/samtools/samtools/releases/download/1.5/samtools-1.5.tar.bz2
RUN tar --bzip2 -xf samtools-1.5.tar.bz2
WORKDIR /bin/samtools-1.5
RUN ./configure
RUN make
RUN rm /bin/samtools-1.5.tar.bz2
ENV PATH $PATH:/bin/samtools-1.5

#Install subread
WORKDIR /bin
RUN apt-get update && apt-get install --yes make libz-dev procps pigz
RUN wget 'https://sourceforge.net/projects/subread/files/subread-2.0.2/subread-2.0.2-source.tar.gz'
RUN tar zxvf subread-2.0.2-source.tar.gz
WORKDIR /bin/subread-2.0.2-source/src
RUN make -f Makefile.Linux
RUN cp -r ../bin/* /usr/bin

# Cleanup
RUN rm -rf /bin/subread-2.0.2-source.tar.gz
RUN apt-get clean
RUN apt-get remove --yes --purge build-essential gcc-multilib apt-utils zlib1g-dev vim git

WORKDIR /
