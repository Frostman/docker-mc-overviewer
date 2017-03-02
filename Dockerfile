FROM ubuntu:xenial

ARG GIT_URL=https://github.com/overviewer/Minecraft-Overviewer
ARG GIT_REF=master

ENV BUILD_DEPS="build-essential python-dev git ca-certificates"
ENV RUNTIME_DEPS="python python-imaging python-numpy"

RUN apt-get update \
    && apt-get install -y --no-install-recommends ${BUILD_DEPS} ${RUNTIME_DEPS} \
    && mkdir /overviewer \
    && cd /overviewer \
    && git init \
    && git remote add origin ${GIT_URL} \
    && git fetch origin ${GIT_REF} \
    && git reset --hard FETCH_HEAD \
    && python setup.py install \
    && apt-get purge -y ${BUILD_DEPS} \
    && apt-get autoremove -y --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /usr/share/icons \
    && rm -rf /usr/share/poppler \
    && rm -rf /usr/share/mime \
    && rm -rf /usr/share/GeoIP

RUN useradd --no-create-home --shell /bin/false --system --uid 1000 overviewer
USER overviewer

ENTRYPOINT ["overviewer.py"]
