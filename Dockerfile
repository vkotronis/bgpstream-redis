FROM python:3.6.7

LABEL maintainer="Dimitrios Mavrommatis <jim.mavrommatis@gmail.com>"

RUN apt-get update && \
    apt-get -y install build-essential zlib1g-dev libbz2-dev libcurl4-openssl-dev python-dev

RUN mkdir /root/src
WORKDIR /root/src

RUN curl -O https://research.wand.net.nz/software/wandio/wandio-4.2.2.tar.gz && \
    tar zxf wandio-4.2.2.tar.gz
WORKDIR /root/src/wandio-4.2.2
RUN ./configure && make && make install && ldconfig

WORKDIR /root/src

RUN curl -LO https://github.com/edenhill/librdkafka/archive/v0.11.1.tar.gz && \
    tar zxf v0.11.1.tar.gz
WORKDIR /root/src/librdkafka-0.11.1
RUN ./configure && make && make install && ldconfig

WORKDIR /root/src

RUN curl -LO https://github.com/CAIDA/libbgpstream/releases/download/v2.0-rc1.2/libbgpstream-2.0.0-rc1.2.tar.gz && \
    tar zxf libbgpstream-2.0.0-rc1.2.tar.gz
WORKDIR /root/src/libbgpstream-2.0.0
RUN ./configure --disable-parser-warnings && make && make install && ldconfig

WORKDIR /root/src

RUN curl -LO https://github.com/CAIDA/pybgpstream/releases/download/v2.0/pybgpstream-2.0.0.tar.gz && \
    tar zxf pybgpstream-2.0.0.tar.gz
WORKDIR /root/src/pybgpstream-2.0.0
RUN python setup.py build_ext && python setup.py install

WORKDIR /root/src

RUN curl -O http://download.redis.io/redis-stable.tar.gz && \
    tar xzvf redis-stable.tar.gz
WORKDIR /root/src/redis-stable
RUN make && make install && ldconfig && \
    mkdir -p /etc/redis/ && cp redis.conf /etc/redis/

WORKDIR /root

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /root/*

ENTRYPOINT ["bash"]
