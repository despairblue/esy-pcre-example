# IMPORTANT:
# Keep the hash in sync with the `scamaybe` image in Dockerfile to keep the
# build and final image binary compatible!
FROM debian:buster@sha256:439a6bae1ef351ba9308fc9a5e69ff7754c14516f6be8ca26975fb564cb7fb76
LABEL maintainer=despair.blue@gmail.com

# For Owl (http://ocaml.xyz/)
# * liblapacke
# * libopenblas
# For something else
# * texinfo
# For esy
# * lbzip2
# * npm
# * curl
# * git
# For ocaml-pcre
# * libpcre3
# hadolint ignore=DL3015
RUN apt-get update \
  && apt-get install -yq \
    build-essential=12.6\
    m4=1.4.18-2 \
    wget=1.20.1-1.1 \
    curl=7.64.0-4+deb10u1 \
    git=1:2.20.1-2+deb10u3 \
    unzip=6.0-23+deb10u1 \
    aspcud=1:1.9.4-2 \
    libshp-dev=1.4.1-3 \
    libplplot-dev=5.14.0+dfsg-3 \
    gfortran=4:8.3.0-1 \
    liblapacke-dev=3.8.0-2 \
    libopenblas-dev=0.3.5+ds-3 \
    texinfo=6.5.0.dfsg.1-4+b1 \
    lbzip2=2.5-2 \
    libpcre3-dev=2:8.39-12 \
    npm=5.8.0+ds6-4+deb10u2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g --unsafe-perm esy@0.6.7

# build scamaybe
COPY ./ /app
WORKDIR /app
RUN esy
