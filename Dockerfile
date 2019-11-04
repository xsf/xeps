# Builds all XEPs by default, HTML & PDF
# docker build . --build-arg NCORES=X --build-arg TARGETS="html pdf"
# from Dockerfile.base
FROM xmppxsf/xeps-base:latest AS builder

ARG NCORES=1
ARG TARGETS="html inbox-html inbox-xml pdf xeplist refs xml"

COPY *.xml xep.* *.css *.xsl *.js *.xsl Makefile /src/
COPY resources/*.pdf /src/resources/
COPY tools/*.py /src/tools/
COPY inbox/*.xml inbox/*.ent inbox/*.dtd /src/inbox/
COPY texml-xsl/*.xsl /src/texml-xsl/

WORKDIR /src
RUN make -j$NCORES $TARGETS

FROM nginx
COPY --from=builder /src/build/ /usr/share/nginx/html/extensions/
RUN chmod a+rX /usr/share/nginx/html/extensions/ -R
