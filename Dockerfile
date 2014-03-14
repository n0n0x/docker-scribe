# VERSION 0.1
# DOCKER-VERSION  0.8.0
# AUTHOR:         Santiago del Castillo
# DESCRIPTION:    Image with Scribe
# TO_BUILD:       docker build -rm -t scribe .
# TO_RUN:         docker run -p 1463:1463 scribe


FROM ubuntu:12.04

MAINTAINER Santiago del Castillo, Version: 0.1.0

RUN apt-get update; \
    apt-get install -y debhelper pbuilder flex bison libglib2.0-dev python2.7-dbg php5-dev mono-gmcs python-dev ant mono-devel libmono-system-web2.0-cil erlang-base ruby1.8-dev python-support python-all python-all-dev python-all-dbg openjdk-6-jdk libcommons-lang3-java libboost-test-dev libevent-dev php5 libqt4-dev libboost-all-dev git

RUN git clone -b 0.9.1 https://github.com/apache/thrift.git

RUN cd /thrift && ./bootstrap.sh && ./configure --with-java=no --with-erlang=no --with-php=no --with-perl=no --with-php_extension=no --with-ruby=no --with-haskell=no --with-go=no && make && make install && make distclean

RUN cd /thrift/contrib/fb303 && ./bootstrap.sh && ./configure --without-java --without-php && make && make install && cd py && python setup.py install && make distclean

RUN git clone https://github.com/facebook/scribe.git 

RUN cd /scribe && ./bootstrap.sh && ./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -DBOOST_FILESYSTEM_VERSION=2" LIBS="-lboost_system -lboost_filesystem" && make && make install && cd lib/py && python setup.py install && make distclean

RUN mkdir /var/lib/scribe/

ADD config/scribe.conf /etc/

# expose scribe
EXPOSE 1463

CMD ["/usr/local/bin/scribed", "-c", "/etc/scribe.conf"]
