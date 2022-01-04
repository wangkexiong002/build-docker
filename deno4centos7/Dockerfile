##
## There may be some configuration defined in .gitattributes which requires latest git binary...
## Alternative solution:
##   1. use ubuntu in multistage build
##   2. use endpoint-repo for centos:7
##        yum install -y https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.10-1.x86_64.rpm \
##        && yum install -y git
##
FROM alpine/git as TOOL
WORKDIR /
ARG DENO_VERSION=1.5.4
RUN git clone --recurse-submodules https://github.com/denoland/deno.git \
    && cd deno && git checkout v${DENO_VERSION}

FROM centos:7 as BASE
COPY --from=TOOL /deno /deno
##
## 1. lexical-core build error
##   https://users.rust-lang.org/t/expected-u32-found-usize-in-lexical-core/62820
##
ARG RUSTC_VERSION=1.49
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain ${RUSTC_VERSION} -y \
    && . ~/.cargo/env \
    && yum groupinstall -y "Development Tools" \
    && cd /deno \
    && cargo build --release

FROM centos:7
LABEL maintainer=wangkexiong
COPY --from=BASE /deno/target/release/deno /usr/local/bin
