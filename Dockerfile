FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

#Runit
RUN apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#SSHD
RUN apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd
RUN sed -i "s/session.*required.*pam_loginuid.so/#session    required     pam_loginuid.so/" /etc/pam.d/sshd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

#To build AMC
RUN apt-get install -y build-essential python-dev python-pip man

#Aerospike
RUN curl -L http://www.aerospike.com/download/server/3.3.22/artifact/ubuntu12 | tar xz && \
    cd aerospike* && \
    dpkg -i aerospike-server*.deb && \
    dpkg -i aerospike-tools*.deb && \
    rm -rf /aerospike*

#AMC
RUN wget -O amc.deb http://www.aerospike.com/download/amc/3.4.7/artifact/ubuntu12 && \
    dpkg -i amc.deb && \
    rm amc.deb

#Add runit services
ADD sv /etc/service 

