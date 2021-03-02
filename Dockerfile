FROM centos:7.8.2003 

RUN yum install -y which wget git make gcc epel-release

RUN cd /root && git clone https://github.com/andypern/tpcds-kit && cd tpcds-kit/tools && \
    make && \
    cp dsdgen /usr/local/bin && \
    cp tpcds.idx /root




