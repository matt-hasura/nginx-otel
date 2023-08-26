ARG VERSION=1.25.2
FROM nginx:${VERSION} as builder

ARG VERSION
ENV NGINX_VERSION=${VERSION}

RUN set -x \
    && apt-get update && apt-get install -y \
        binutils \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        gnupg1 \
        libc-ares-dev \
        libcurl4-openssl-dev \
        libpcre3-dev \
        libre2-dev \
        libssl-dev \
        libsystemd-dev \
        pkg-config \
        zlib1g-dev

WORKDIR /opt

RUN set -x \
    && curl -s http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o nginx-${NGINX_VERSION}.tar.gz \
    && tar -xvf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && ./configure --with-compat \
    && cd .. \
    && git clone https://github.com/nginxinc/nginx-otel.git \
    && cd nginx-otel \
    && sed -i 's/18dda3c586b2607d8daead6b97922e59d867bb7d # v1.46.6/a3f10052090539cd3e19aa8e04f3bf8eceae2964 # v1.52.0/g' CMakeLists.txt \
    && sed -i 's/57bf8c2b0e85215a61602f559522d08caa4d2fb8 # v1.8.1/d56a5c702fc2154ef82400df4801cd511ffb63ea # v1.8.2/g' CMakeLists.txt \
    && mkdir build \
    && cd build \
    && cmake \
        -DNGX_OTEL_NGINX_BUILD_DIR=/opt/nginx-${NGINX_VERSION}/objs .. \
    && make \
    && strip -s /opt/nginx-otel/build/ngx_otel_module.so

ARG VERSION=1.25.2
FROM nginx:${VERSION}

LABEL maintainer="Matt Kryshak"

COPY --from=builder /opt/nginx-otel/build/ngx_otel_module.so /usr/lib/nginx/modules/ngx_otel_module.so

RUN set -x \
    && apt-get update && apt-get install --no-install-suggests --no-install-recommends -y \
        libc-ares-dev \
        libre2-9 \
    && apt-get remove --purge --auto-remove -y \
    && rm -rf /var/lib/apt/lsits/*
