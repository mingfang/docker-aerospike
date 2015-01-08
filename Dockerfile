FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8

#Runit
RUN apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

#Aerospike
RUN curl -L http://www.aerospike.com/download/server/3.4.0/artifact/ubuntu12 | tar xz && \
    cd aerospike* && \
    dpkg -i aerospike-server*.deb && \
    dpkg -i aerospike-tools*.deb && \
    rm -rf /aerospike*

#To build AMC
RUN apt-get install -y build-essential python-dev python-pip man

#AMC
RUN wget -O amc.deb http://www.aerospike.com/download/amc/3.5.0/artifact/ubuntu12 && \
    dpkg -i amc.deb && \
    rm amc.deb

#Add runit services
ADD sv /etc/service 

