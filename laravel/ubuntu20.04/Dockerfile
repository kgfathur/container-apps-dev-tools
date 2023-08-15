ARG SOURCE_IMAGE

FROM ${SOURCE_IMAGE}

ARG WWW_ROOT="/usr/share/nginx/html" \
  APP_HOME="/usr/share/nginx/html" \
  APP_USER="nginx" \
  APP_USERID=1000 \
  APP_VERSION \
  NGINX_VERSION="1.22" \
  PHP_VERSION="7.4" \
  NODE_VERSION="18" \
  LARAVEL_VERSION=8

ENV NAME=laravel \
  APP_VERSION=$APP_VERSION \
  NGINX_VERSION=${NGINX_VERSION} \
  PHP_VERSION=${PHP_VERSION} \
  NODE_VERSION=$NODE_VERSION \
  LARAVEL_VERSION=${LARAVEL_VERSION} \
  OS_NAME=ubuntu \
  OS_VERSION=20.04 \
  OS_CODENAME=focal \
  OS_FULLNAME='Focal Fossa' \
  APP_HOME=$APP_HOME \
  WWW_ROOT=$WWW_ROOT \
  APP_USER=$APP_USER \
  APP_USERID=$APP_USERID

ENV SUMMARY="Laravel ${LARAVEL_VERSION}}} image with rootless priviledge based on and ${OS_NAME} ${OS_VERSION} (${OS_FULLNAME})" \
  DESCRIPTION="Laravel is a free and open-source"

LABEL maintainer="kgfathur" \
      name="${NAME}" \
      summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      org.opencontainers.image.source="https://github.com/kgfathur/container-apps-dev-tools.git" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="Laravel ${LARAVEL_VERSION}" \
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