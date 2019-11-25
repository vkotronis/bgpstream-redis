FROM caida/bgpstream:2.0.0-rc2

LABEL maintainer="Dimitrios Mavrommatis <jim.mavrommatis@gmail.com>"

RUN apt-get update && \
    apt-get -y install build-essential python3-dev python3-setuptools

RUN mkdir /root/src
WORKDIR /root/src

RUN curl -O http://download.redis.io/redis-stable.tar.gz && \
    tar xzvf redis-stable.tar.gz
WORKDIR /root/src/redis-stable
RUN make && make install && ldconfig && \
    mkdir -p /etc/redis/ && cp redis.conf /etc/redis/

WORKDIR /root

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /root/* && \
    ln -s /usr/bin/python3 /usr/local/bin/python

ENTRYPOINT ["bash"]
