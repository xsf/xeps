# Builds all XEPs by default, HTML & PDF
# docker build . --build-arg NCORES=X --build-arg TARGETS="html pdf"
# from Dockerfile.base
FROM xmppxsf/xeps-base:latest

ARG NCORES=1
ARG TARGETS="html inbox-html inbox-xml pdf"

COPY *.xml xep.* *.css *.xsl *.js *.xsl Makefile /src/
COPY resources/*.pdf /src/resources/
COPY inbox/*.xml inbox/*.ent inbox/*.dtd /src/inbox/

WORKDIR /src
RUN OUTDIR=/var/www/html/extensions/ make -j$NCORES $TARGETS

EXPOSE 80

CMD /usr/sbin/nginx -g 'daemon off;'
