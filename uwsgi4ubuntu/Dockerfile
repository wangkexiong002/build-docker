FROM ubuntu:jammy as BUILDER

ARG UWSGI_VERSION=2.0.20
ARG PYTHON_VERSION=3.9.13
ARG PYTHON_CONFIG_ARGS="--enable-shared --enable-ipv6 --with-system-expat"
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /home
RUN apt-get update
RUN apt-get install -y make build-essential wget curl llvm git file rsync patch
RUN apt-get install -y libssl-dev zlib1g-dev libexpat1-dev libbz2-dev libreadline-dev \
                       libsqlite3-dev libncurses5-dev libffi-dev liblzma-dev xz-utils \
                       libpcre3-dev libssl-dev libcap-dev libxml2-dev libjansson-dev \
                       uuid-dev tk-dev
RUN curl -fsSL https://pyenv.run | bash
RUN wget http://projects.unbit.it/downloads/uwsgi-${UWSGI_VERSION}.tar.gz && tar xzvf uwsgi-${UWSGI_VERSION}.tar.gz

ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"
RUN PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIG_ARGS}" pyenv install ${PYTHON_VERSION} -v
RUN pyenv global ${PYTHON_VERSION}
RUN cd uwsgi-${UWSGI_VERSION} && make package && python uwsgiconfig.py --plugin plugins/python core

RUN mkdir -p /buildfiles/usr/bin /buildfiles/usr/lib/uwsgi /buildfiles/root
RUN cp /home/uwsgi-${UWSGI_VERSION}/uwsgi /buildfiles/usr/bin/. && \
    cp /home/uwsgi-${UWSGI_VERSION}/python_plugin.so /buildfiles/usr/lib/uwsgi/.
RUN cp -r /root/.pyenv /buildfiles/root/
RUN find /buildfiles -name *.pyc -o -name *.pyo | xargs rm -rf
RUN find /buildfiles -exec file {} + | grep -i 'elf.*not stripped' | awk -F: '{print $1}' | xargs strip

FROM ubuntu:jammy
LABEL maintainer=wangkexiong

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && export DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get install -y libssl3 zlib1g libexpat1 libbz2-1.0 libreadline8 libsqlite3-0 libncurses5 \
                          libffi8 liblzma5 libpcre3 libcap2 libxml2 libjansson4 libuuid1 libtk \
    && apt-get autoremove -y && apt-get clean all \
    && rm -rf /var/cache/* /var/log/* /var/lib/* /tmp/*
RUN mkdir -p /app && useradd -M uwsgi
COPY --from=BUILDER /buildfiles /

ENV PATH="/root/.pyenv/shims:/root/.pyenv/bin:${PATH}"
WORKDIR /app
EXPOSE 3031

CMD if [ -f uwsgi.ini ]; then /bin/bash -l -c "uwsgi --ini uwsgi.ini"; else /bin/bash; fi

