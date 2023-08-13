ARG SOURCE_IMAGE
ARG APP_HOME=/app
FROM ${SOURCE_IMAGE}

ENV NAME=laravel \
  NODE_VERSION=18 \
  NGINX_VERSION=1.22 \
  PHP_VERSION=8.1 \
  LARAVEL_VERSION=9 \
  OS_NAME=ubuntu \
  OS_VERSION=22.04 \
  OS_CODENAME=jammy \
  OS_FULLNAME='Jammy Jellyfish' \
  APP_HOME=${APP_HOME}

ENV SUMMARY="NodeJS ${NODE_VERSION}} image with rootless priviledge based on and ${OS_NAME} ${OS_VERSION} (${OS_FULLNAME})" \
  DESCRIPTION="NodeJS is a free and open-source"

LABEL maintainer="kgfathur" \
      name="${NAME}" \
      summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      org.opencontainers.image.source="https://github.com/kgfathur/container-apps-dev-tools.git" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="NodeJS ${NODE_VERSION}}" \
      io.openshift.expose-services="8080:http" \
      usage="docker run -dit -p 8080:8080 ${NAME}}:${OS_NAME}${OS_VERSION}"

COPY ./src /src

RUN chmod +x /src/setup.sh \
  && bash /src/setup.sh \
  && rm -vrf /src

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
STOPSIGNAL SIGQUIT
EXPOSE 8080
USER 1000

CMD ["node", "app.js"]