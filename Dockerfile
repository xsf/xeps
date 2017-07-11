FROM xmppxsf/xeps-base:latest

COPY *.xml xep.* *.css *.xsl *.js *.xsl Makefile /src/
COPY resources/*.pdf /src/resources/

WORKDIR /src
RUN OUTDIR=/var/www/html/extensions/ make -j5 html pdf

EXPOSE 80

CMD /usr/sbin/nginx -g 'daemon off;'
