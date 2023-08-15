ARG SOURCE_IMAGE

FROM ${SOURCE_IMAGE}

ARG WWW_ROOT="/usr/share/nginx/html" \
  APP_HOME="/usr/share/nginx/html" \
  APP_USER="nginx" \
  APP_USERID=1000 \
  APP_VERSION \
  NGINX_VERSION="1.22" \
  PHP_VERSION="7.4"

ENV NAME=php-fpm \
  APP_VERSION=$APP_VERSION \
  NGINX_VERSION=$NGINX_VERSION \
  PHP_VERSION=$PHP_VERSION \
  OS_NAME=ubuntu \
  OS_VERSION=20.04 \
  OS_CODENAME=focal \
  OS_FULLNAME='Focal Fossa' \
  APP_HOME=$APP_HOME \
  WWW_ROOT=$WWW_ROOT \
  APP_USER=$APP_USER \
  APP_USERID=$APP_USERID

ENV SUMMARY="NGINX ${NGINX_VERSION} image with rootless priviledge based on ${OS_NAME} ${OS_VERSION} (${OS_FULLNAME})" \
  DESCRIPTION="NGINX is a web server and a reverse proxy server for HTTP, SMTP, POP3 and IMAP \
protocols, with a strong focus on high concurrency, performance and low memory usage. The container \
image provides a containerized packaging of the NGINX ${NGINX_VERSION} daemon. The image can be used \
as a base image for other applications based on NGINX ${NGINX_VERSION} web server. \
NGINX server image can be extended using source-to-image tool."

LABEL maintainer="kgfathur" \
      name="${NAME}" \
      summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      org.opencontainers.image.source="https://github.com/kgfathur/container-apps-dev-tools.git" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="NGINX ${NGINX_VERSION} with PHP-FPM ${PHP_VERSION}" \
      io.openshift.expose-services="8080:http" \
      usage="docker run -dit -p 8080:8080 ${NAME}:${OS_NAME}${OS_VERSION}"

COPY ./src /src

RUN chmod +x /src/setup.sh \
  && bash /src/setup.sh \
  && rm -vrf /src

WORKDIR ${APP_HOME}
ENTRYPOINT ["/entrypoint.sh"]

STOPSIGNAL SIGQUIT

EXPOSE 8080
USER ${APP_USERID}

CMD ["nginx", "-g", "daemon off;"]