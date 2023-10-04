FROM ubuntu:latest

COPY dpkg-excludes /etc/dpkg/dpkg.cfg.d/excludes
COPY start.sh /

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install locales wget unzip tzdata && \
    locale-gen en_US.UTF-8 && \
    locale-gen de_CH.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
	
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN cd /opt/ && \
    wget https://github.com/micromdm/scep/releases/download/v2.1.0/scepserver-linux-amd64-v2.1.0.zip && \
    unzip scepserver-linux-amd64-v2.1.0.zip && \
    rm -f scepserver-linux-amd64-v2.1.0.zip && \
    mv scepserver-linux-amd64 /usr/sbin && \
    chmod 0750 /start.sh

ENTRYPOINT ["/start.sh"]
