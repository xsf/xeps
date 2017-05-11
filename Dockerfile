FROM debian:8
MAINTAINER XSF Editors <editor@xmpp.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y xsltproc libxml2-utils libxml2 texlive fonts-inconsolata make nginx

RUN mkdir /src
COPY *.xml xep.* *.css *.xsl /src/
COPY Makefile *.js  /src/
WORKDIR /src
RUN mkdir /var/www/html/extensions
RUN OUTDIR=/var/www/html/extensions/ make html

EXPOSE 80

CMD /usr/sbin/nginx -g 'daemon off;'
