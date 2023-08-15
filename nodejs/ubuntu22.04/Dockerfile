ARG SOURCE_IMAGE

FROM ${SOURCE_IMAGE}

ARG APP_HOME="/app" \
  APP_USER="app" \
  APP_USERID=1000 \
  APP_VERSION \
  NODE_VERSION="18"

ENV NAME=nodejs \
  NODE_VERSION=18 \
  OS_NAME=ubuntu \
  OS_VERSION=22.04 \
  OS_CODENAME=jammy \
  OS_FULLNAME='Jammy Jellyfish' \
  APP_HOME=$APP_HOME \
  WWW_ROOT=$WWW_ROOT \
  APP_USER=$APP_USER \
  APP_USERID=$APP_USERID

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

CMD ["node", "app.js"]