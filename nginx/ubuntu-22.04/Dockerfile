ARG SOURCE_IMAGE
FROM ${SOURCE_IMAGE}

ENV NAME=nginx \
  NGINX_VERSION=1.22 \
  OS_NAME=ubuntu \
  OS_VERSION=22.04 \
  OS_CODENAME=jammy \
  OS_FULLNAME='Jammy Jellyfish'

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
      io.k8s.display-name="NGINX ${NGINX_VERSION}" \
      io.openshift.expose-services="8080:http" \
      usage="docker run -dit -p 8080:8080 ${NAME}}:${OS_NAME}${OS_VERSION}"

COPY ./src /src

RUN chmod +x /src/setup.sh \
  && bash /src/setup.sh \
  && rm -vrf /src

ENTRYPOINT ["/entrypoint.sh"]

STOPSIGNAL SIGQUIT

EXPOSE 8080
USER 1000

CMD ["nginx", "-g", "daemon off;"]