FROM ruby:2.4

RUN apt-get install curl autoconf automake libtool pkg-config

RUN mkdir -p /opt/libpostal && cd /opt/libpostal && \
    git clone https://github.com/openvenues/libpostal && \
    cd libpostal && git checkout tags/v1.0.0 && \
    ./bootstrap.sh && \
    mkdir -p /opt/libpostal/data && \
    ./configure --datadir=/opt/libpostal/data && \
    make && \
    make install

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle install

ONBUILD COPY . /usr/src/app
