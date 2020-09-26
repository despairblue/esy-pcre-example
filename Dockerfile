#
# BUILD IMAGE
#
FROM gcr.io/hosting-214616/scamaybe-base:upgrade-docker-image as build
LABEL maintainer=despair.blue@gmail.com

COPY ./ /app
WORKDIR /app

RUN esy
RUN esy test

#
# FINAL IMAGE
#

# IMPORTANT:
# Keep the hash in sync with the base image in base.Dockerfile to keep the
# build and final image binary compatible!
FROM debian:buster@sha256:439a6bae1ef351ba9308fc9a5e69ff7754c14516f6be8ca26975fb564cb7fb76 as scamaybe
LABEL maintainer=despair.blue@gmail.com

# For Owl (http://ocaml.xyz/)
# * liblapacke
# * libopenblas
# For ocaml-pcre
# * libpcre3
# For docker (https://github.com/Yelp/dumb-init)
# * dumb-init
RUN apt-get update \
  && apt-get install -yq --no-install-recommends \
    liblapacke=3.8.0-2 \
    libopenblas-base=0.3.5+ds-3 \
    libpcre3=2:8.39-12 \
    dumb-init=1.2.2-1.1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/_build/install/default/bin/Server /usr/bin/Server
RUN mkdir /app
WORKDIR /app
COPY --from=build /app/all-descriptions.txt /app/all-descriptions.txt
COPY --from=build /app/scam-descriptions.txt /app/scam-descriptions.txt

ENV ALL_DESCRIPTIONS=all-descriptions.txt
ENV SCAM_DESCRIPTIONS=scam-descriptions.txt

ENTRYPOINT ["dumb-init", "--"]
CMD ["Server"]
