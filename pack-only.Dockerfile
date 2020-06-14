FROM nginx:1-alpine
RUN mkdir /usr/share/nginx/html/extensions/
COPY build/ /usr/share/nginx/html/extensions/
RUN sed -ri '/root\s+\/usr\/share\/nginx\/html/s/^(.+)$/\1\nautoindex on;/' /etc/nginx/conf.d/default.conf
EXPOSE 80
