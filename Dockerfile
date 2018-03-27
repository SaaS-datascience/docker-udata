##########################################
# Dockerfile for udata
##########################################

FROM debian:jessie
ENV http_proxy http://192.168.2.10:3128
ENV https_proxy http://192.168.2.10:3128

# File Author / Maintainer
MAINTAINER Axel Haustant

# Install uData system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essential Tools
    tar git wget curl build-essential pkg-config file \
    # Python tools
    python python-dev python-pip\
    # Pillow
    libjpeg-dev zlib1g-dev libpng12-dev libtiff5-dev libfreetype6-dev \
    liblcms2-dev libopenjpeg-dev libwebp-dev libpng12-dev \
    # lxml dependencies
    libxml2-dev libxslt1-dev \
    # Misc dependencies
    liblzma-dev libyaml-dev libffi-dev \
    # uWSGI features
    libpcre3-dev \
    # Clean up
    && apt-get autoremove\
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install udata and all known plugins
RUN pip install --proxy $https_proxy --pre udata udata-piwik udata-gouvfr udata-youckan uwsgi gevent raven

RUN mkdir -p /udata/fs

COPY config/udata.cfg entrypoint.sh /udata/
COPY uwsgi/*.ini /udata/uwsgi/

WORKDIR /udata

VOLUME /udata/fs

ENV UDATA_SETTINGS /udata/udata.cfg

EXPOSE 7000 7001

HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:7000/ || exit 1

ENTRYPOINT ["/udata/entrypoint.sh"]
CMD ["uwsgi"]
