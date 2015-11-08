FROM debian:jessie
MAINTAINER Ciro S. Costa <ciro.costa@usp.br>
LABEL Description="Instancia servidor lighty vulnerável (CVE-2014-2323)"

RUN echo "deb http://ftp.br.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://ftp.br.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list

RUN apt-get -y update             && \ 
    apt-get -y build-dep lighttpd && \ 
    apt-get                          \ 
      install -y gcc vim curl        \ 
      mysql-client                   \ 
      net-tools

WORKDIR /usr
RUN curl https://codeload.github.com/lighttpd/lighttpd1.4/tar.gz/lighttpd-1.4.34 \ 
    | tar xvz

WORKDIR /usr/lighttpd1.4-lighttpd-1.4.34
RUN ./autogen.sh                   && \
    ./configure --with-mysql       && \
    make && make install

WORKDIR /usr
RUN mkdir -p lighttpd/redes   && \
    mkdir -p lighttpd/mac0448 && \
    mkdir -p lighttpd/mac5910

COPY common/mac0448/index.html /usr/lighttpd/mac0448/index.html
COPY common/mac5910/index.html /usr/lighttpd/mac5910/index.html
COPY common/redes/index.html /usr/lighttpd/redes/index.html
COPY common/lighttpd.conf /usr/lighttpd/lighttpd.conf

EXPOSE 80

CMD ["lighttpd", "-f", "/usr/lighttpd/lighttpd.conf"]