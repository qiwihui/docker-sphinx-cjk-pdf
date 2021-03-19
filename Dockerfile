FROM debian:buster
LABEL MAINTAINER "qiwihui <qwh005007@gmail.com>"

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		python3-pip \
		python3-setuptools \
	&& pip3 install Sphinx \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		make \
		texlive \
		texlive-xetex \
		texlive-latex-extra \
		texlive-lang-cjk \
		fonts-noto-cjk \
		ttf-mscorefonts-installer \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /root/.cache \
	&& find /usr/local/ -type f -name '*.pyc' -delete

# install su-exec
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		gcc curl libc6-dev \
	&& curl -fsSL https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c -o /tmp/su-exec.c \
	&& gcc -Wall -Werror -g -o /usr/bin/su-exec /tmp/su-exec.c \
	&& rm -f /tmp/su-exec.c \
	&& apt-get remove --purge --auto-remove -y gcc curl libc6-dev \
	&& rm -rf /var/lib/apt/lists/*

# install common tools
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		graphviz \
	&& rm -rf /var/lib/apt/lists/*

ADD entry.sh /entry.sh

VOLUME ["/sphinx"]
WORKDIR /sphinx

ENTRYPOINT ["/entry.sh"]
