FROM debian:8
MAINTAINER XSF Editors <editor@xmpp.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y xsltproc libxml2-utils libxml2 texlive fonts-inconsolata make nginx

RUN mkdir /src
COPY *.xml xep.* *.css *.xsl *.js *.xsl Makefile /src/
RUN mkdir /src/resources
COPY resources/*.pdf /src/resources/
WORKDIR /src
RUN apt-get install -y curl python python-pip texlive-xetex 
RUN curl https://pilotfiber.dl.sourceforge.net/project/getfo/texml/texml-2.0.2/texml-2.0.2.tar.gz -o texml-2.0.2.tar.gz && tar -xf texml-2.0.2.tar.gz && pip install texml-2.0.2/ && rm -rf texml-2.0.2
RUN apt-get install -y texlive-fonts-recommended texlive-fonts-extra
RUN mkdir /var/www/html/extensions
RUN OUTDIR=/var/www/html/extensions/ make html pdf

RUN cat /sys/fs/cgroup/cpuset/cpuset.cpus || true
RUN cat /proc/cpuinfo || true

EXPOSE 80

CMD /usr/sbin/nginx -g 'daemon off;'
