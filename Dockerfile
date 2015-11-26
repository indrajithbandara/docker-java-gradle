FROM debian:8

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=45 \
    JAVA_VERSION_BUILD=14 \
    JAVA_PACKAGE=jdk \
    JAVA_HOME=/opt/jdk \
    GRADLE_VERSION=2.8 \
    GRADLE_HOME=/opt/gradle \
    COMPOSE_VERSION=1.5.1 \
    PATH=$PATH:${JAVA_HOME}/bin:${GRADLE_HOME}:${GRADLE_HOME}/bin

# install required packages
RUN apt-get update -qq && apt-get -y -qq --no-install-recommends install locales unzip bash curl wget ca-certificates

# set locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.utf8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# install oracle java
RUN mkdir -p /tmp/java && cd /tmp/java && \
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\
      http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | gunzip -c - | tar -xf - && \
    mv jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/ ${JAVA_HOME}

# install gradle
RUN mkdir -p /tmp/gradle ${GRADLE_HOME} && cd /tmp/gradle && \
    wget -qO- -O gradle.zip https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip -qq gradle.zip && \
    mv ./gradle-${GRADLE_VERSION}/* ${GRADLE_HOME}/

# install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) \
      > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# cleanup
RUN apt-get -y -qq purge unzip curl wget ca-certificates && rm -rf /var/lib/apt/lists/* && apt-get clean
RUN rm -rf /tmp/* /var/tmp/* \
    ${JAVA_HOME}/*src.zip \
    ${JAVA_HOME}/lib/missioncontrol \
    ${JAVA_HOME}/lib/visualvm \
    ${JAVA_HOME}/lib/*javafx* \
    ${JAVA_HOME}/jre/lib/plugin.jar \
    ${JAVA_HOME}/jre/lib/ext/jfxrt.jar \
    ${JAVA_HOME}/jre/bin/javaws \
    ${JAVA_HOME}/jre/lib/javaws.jar \
    ${JAVA_HOME}/jre/lib/desktop \
    ${JAVA_HOME}/jre/plugin \
    ${JAVA_HOME}/jre/lib/deploy* \
    ${JAVA_HOME}/jre/lib/*javafx* \
    ${JAVA_HOME}/jre/lib/*jfx* \
    ${JAVA_HOME}/jre/lib/amd64/libdecora_sse.so \
    ${JAVA_HOME}/jre/lib/amd64/libprism_*.so \
    ${JAVA_HOME}/jre/lib/amd64/libfxplugins.so \
    ${JAVA_HOME}/jre/lib/amd64/libglass.so \
    ${JAVA_HOME}/jre/lib/amd64/libgstreamer-lite.so \
    ${JAVA_HOME}/jre/lib/amd64/libjavafx*.so \
    ${JAVA_HOME}/jre/lib/amd64/libjfx*.so \

CMD []
