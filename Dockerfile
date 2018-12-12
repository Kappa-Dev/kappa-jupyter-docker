FROM debian:stable-slim
MAINTAINER pierre.boutillier@laposte.net

USER root
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends python3-pip jupyter-notebook python3-ipykernel \
    python3-matplotlib python3-future python3-requests wget && \
  apt-get autoremove -y && apt-get clean -y
RUN pip3 install kappy

RUN TINI_VERSION="0.18.0" && \
    wget --quiet https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}-amd64.deb && \
    dpkg -i tini_${TINI_VERSION}-amd64.deb && \
    rm *.deb
ENTRYPOINT ["/usr/bin/tini", "--"]

ARG USER_UID=1000
RUN useradd -u $USER_UID -m -d /notebook -s /bin/bash user
USER user

EXPOSE 8888
WORKDIR /notebook
CMD ["jupyter-notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
