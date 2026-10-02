# Builds all XEPs by default, HTML & PDF
# docker build . --build-arg NCORES=X --build-arg TARGETS="html pdf"
# from Dockerfile.base
FROM xmppxsf/xeps-base:latest as build

ARG NCORES=1
ARG TARGETS="html inbox-html inbox-xml pdf xeplist refs xml"

COPY *.xml xep.* *.css *.xsl *.js *.xsl Makefile refs-LICENSE /src/
COPY resources/*.pdf /src/resources/
COPY tools/*.py /src/tools/
COPY inbox/*.xml inbox/*.ent inbox/*.dtd /src/inbox/
COPY texml-xsl/*.xsl /src/texml-xsl/

WORKDIR /src
RUN OUTDIR=/var/www/html/extensions/ make -j$NCORES $TARGETS
RUN bash -c 'rm -f /var/www/html/extensions/*.{log,aux,toc,tex,tex.xml,out}'

FROM nginx:1-alpine
RUN mkdir /usr/share/nginx/html/extensions/
COPY --from=build /var/www/html/extensions/ /usr/share/nginx/html/extensions/
RUN sed -ri '/root\s+\/usr\/share\/nginx\/html/s/^(.+)$/\1\nautoindex on;/' /etc/nginx/conf.d/default.conf
EXPOSE 80
