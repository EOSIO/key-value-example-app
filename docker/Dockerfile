FROM ubuntu:18.04

### base
RUN yes | unminimize \
 && apt-get update \
 && apt-get install -yq \
     binutils-gold \
     build-essential \
     clang-tools-8 \
     curl \
     doxygen \
     g++-8 \
     git \
     jq \
     less \
     libcurl4-gnutls-dev \
     libgflags-dev \
     libgmp3-dev \
     libssl-dev \
     libusb-1.0-0-dev \
     lld-8 \
     llvm-7 \
     llvm-7-dev \
     locales \
     nano \
     nginx \
     ninja-build \
     pkg-config \
     python \
     sudo \
     vim \
     software-properties-common \
     wget \
     xz-utils \
     zlib1g-dev \
 && update-alternatives --remove-all cc \
 && update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-8 100 \
 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 100 \
 && update-alternatives --remove-all c++ \
 && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-8 100 \
 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 100 \
 && update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 100 \
 && locale-gen en_US.UTF-8 \
 && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
 && apt-get install -yq \
     nodejs \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
 && npm i -g yarn typescript
ENV LANG=en_US.UTF-8

### cmake
RUN curl -LO https://cmake.org/files/v3.19/cmake-3.19.0.tar.gz \
 && tar -xzf cmake-3.19.0.tar.gz \
 && cd cmake-3.19.0 \
 && ./bootstrap --prefix=/usr/local \
 && make -j8 \
 && make install \
 && rm -rf cmake-3.19.0.tar.gz cmake-3.19.0

### boost
RUN curl -LO https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2 \
 && tar -xjf boost_1_72_0.tar.bz2 \
 && cd boost_1_72_0 \
 && ./bootstrap.sh --prefix=/usr/local \
 && ./b2 --with-iostreams --with-date_time --with-filesystem --with-system --with-program_options --with-chrono --with-test -j8 install \
 && rm -rf boost_1_72_0.tar.bz2 boost_1_72_0

### libpq and libpqxx
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && apt-get update && apt-get -y install libpq-dev

### Remove after release
RUN mkdir -p /opt/eosio/binaries
COPY ./binaries /opt/eosio/binaries

### eosio
#RUN wget https://github.com/EOSIO/eos/releases/download/v2.0.0/eosio_2.0.0-1-ubuntu-18.04_amd64.deb \
# && apt-get update && apt install -y ./eosio_2.0.0-1-ubuntu-18.04_amd64.deb \
# && rm ./eosio_2.0.0-1-ubuntu-18.04_amd64.deb
RUN apt-get update \
 && sudo apt-get install -y /opt/eosio/binaries/eosio_2.1.0-alpha2_amd64.deb \
 && rm /opt/eosio/binaries/eosio_2.1.0-alpha2_amd64.deb

### CDT
#RUN wget https://github.com/EOSIO/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb \
# && apt-get update && apt install -y ./eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb \
# && rm ./eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
RUN apt-get update \
 && sudo apt-get install -y /opt/eosio/binaries/eosio.cdt_1.7.0-develop_amd64.deb \
 && rm /opt/eosio/binaries/eosio.cdt_1.7.0-develop_amd64.deb

RUN echo "COPYING APP CONTRACTS"
RUN mkdir -p /opt/eosio/bin/contracts
COPY ./contracts /opt/eosio/bin/contracts
COPY ./deploy_contracts.sh /opt/eosio/bin/

RUN echo "DEPLOYING CONTRACTS"
RUN mkdir -p /opt/eosio/bin/config-dir
RUN /bin/bash /opt/eosio/bin/deploy_contracts.sh
