ARG SOURCE_IMAGE
FROM ${SOURCE_IMAGE}

ENV NAME=laravel \
  NGINX_VERSION=1.22 \
  PHP_VERSION=8.1 \
  LARAVEL_VERSION=9 \
  OS_NAME=ubuntu \
  OS_VERSION=22.04 \
  OS_CODENAME=jammy \
  OS_FULLNAME='Jammy Jellyfish'

ENV SUMMARY="Laravel ${LARAVEL_VERSION} image with rootless priviledge based on NGINX ${NGINX_VERSION} and ${OS_NAME} ${OS_VERSION} (${OS_FULLNAME})" \
  DESCRIPTION="Laravel is a free open-source PHP framework. It provides web developers tools and resources for building modern PHP web applications."

LABEL maintainer="kgfathur" \
      name="${NAME}" \
      summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      org.opencontainers.image.source="https://github.com/kgfathur/container-apps-dev-tools.git" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="Laravel ${LARAVEL_VERSION} with NGINX ${NGINX_VERSION} and PHP-FPM ${PHP_VERSION}" \
      io.openshift.expose-services="8080:http" \
      usage="docker run -dit -p 8080:8080 ${NAME}}:${OS_NAME}${OS_VERSION}"

USER root

ENTRYPOINT ["/entrypoint.sh"]

STOPSIGNAL SIGQUIT

EXPOSE 8080
USER 1000

CMD ["nginx", "-g", "daemon off;"]