FROM alpine:3.10

LABEL "name"="helm-package-action"
LABEL "maintainer"="Markus Maga <markus@maga.se>"
LABEL "version"="0.1.0"

LABEL "repository"="http://github.com/flydiverny/helm-package-action"
LABEL "homepage"="http://github.com/flydiverny/helm-package-action"

LABEL "com.github.actions.name"="Helm Package"
LABEL "com.github.actions.description"="Action for running helm package on helm charts to create versioned chart archive file(s)"
LABEL "com.github.actions.icon"="anchor"
LABEL "com.github.actions.color"="blue"

ARG K8S_VERSION=v1.16.9
ARG HELM_VERSION=v3.2.3
ENV HELM_HOME=/usr/local/helm
ENV APK_REPOSITORY_MAIN=https://registry.kroger.com/artifactory/alpine/v3.10/main/
ENV APK_REPOSITORY_COMMUNITY=https://registry.kroger.com/artifactory/alpine/v3.10/community/

COPY deps /usr/local/bin/

RUN echo ${APK_REPOSITORY_MAIN} > /etc/apk/repositories && \
    echo ${APK_REPOSITORY_COMMUNITY} >> /etc/apk/repositories && \
    apk -v --update --no-cache add \
        ca-certificates \
        bash && \
    chmod +x /usr/local/bin/*

COPY ./helm-package.sh /usr/bin/helm-package

ENTRYPOINT ["helm-package"]
CMD ["help"]
