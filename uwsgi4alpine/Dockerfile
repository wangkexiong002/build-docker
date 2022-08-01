FROM alpine:3.16 as BUILDER

ARG UWSGI_VERSION=2.0.20
ARG PYTHON_VERSION=3.9.13
ARG PYTHON_CONFIG_ARGS="--enable-shared --enable-ipv6 --with-system-expat"

WORKDIR /home
RUN apk add bash wget curl git rsync findutils file patch gcc make linux-headers musl-dev
RUN apk add readline-dev bzip2-dev sqlite-dev expat-dev libffi-dev zlib-dev openssl-dev xz-dev ncurses-dev \
            pcre-dev jansson-dev libxml2-dev openssl-dev libcap-dev util-linux-dev tk-dev
RUN curl -fsSL https://pyenv.run | bash
RUN wget http://projects.unbit.it/downloads/uwsgi-${UWSGI_VERSION}.tar.gz && tar xzvf uwsgi-${UWSGI_VERSION}.tar.gz

ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"
RUN bash -c "PYTHON_CONFIGURE_OPTS=\"${PYTHON_CONFIG_ARGS}\" pyenv install ${PYTHON_VERSION} -v"
RUN bash -c "pyenv global ${PYTHON_VERSION}"
RUN bash -c "cd uwsgi-${UWSGI_VERSION} && make package && \
             python uwsgiconfig.py --plugin plugins/python core"

RUN mkdir -p /buildfiles/usr/bin /buildfiles/usr/lib/uwsgi /buildfiles/root
RUN cp /home/uwsgi-${UWSGI_VERSION}/uwsgi /buildfiles/usr/bin/. && \
    cp /home/uwsgi-${UWSGI_VERSION}/python_plugin.so /buildfiles/usr/lib/uwsgi/.
RUN cp -r /root/.pyenv /buildfiles/root/
RUN find /buildfiles -name *.pyc -o -name *.pyo | xargs rm -rf
RUN find /buildfiles -exec file {} + | grep -i 'elf.*not stripped' | awk -F: '{print $1}' | xargs strip

FROM alpine:3.16
LABEL maintainer="wangkexiong"

RUN apk add --no-cache bash readline bzip2 sqlite-libs expat libffi zlib openssl xz ncurses pcre jansson libxml2 openssl libcap libuuid tk
RUN mkdir -p /app && adduser -D -H uwsgi
COPY --from=BUILDER /buildfiles /

ENV PATH="/root/.pyenv/shims:/root/.pyenv/bin:${PATH}"
WORKDIR /app
EXPOSE 3031

CMD if [ -f uwsgi.ini ]; then /bin/bash -l -c "uwsgi --ini uwsgi.ini"; else /bin/bash; fi

