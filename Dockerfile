FROM jenkins/jenkins:lts

#Disable SetupWizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false -Duser.timezone=America/Sao_Paulo
#Define config for Jenkins Configuration as Code Plugin
ENV CASC_JENKINS_CONFIG /var/jenkins_home/config-server.yaml
ENV MAVEN_HOME /opt/apache-maven-3.8.3
LABEL Renato-Gomes-Silvério <renatogomessilverio@gmail>

SHELL ["/bin/bash", "-c"]

USER root 

RUN apt-get update && \
apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
apt-get update && \
apt-get -y install docker-ce htop vim wget net-tools sudo cmake gcc make g++ curl

#Clean and disable root access
RUN set -e \
    export DEBIAN_FRONTEND=noninteractive \
    dpkg-divert --local --rename --add /sbin/initctl \
    && (echo "Yes, do as I say!" | apt-get remove --force-yes login) \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

#Install Maven
ARG MAVEN_VERSION=3.8.4
ARG USER_HOME_DIR="/opt"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

#Install Maven
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
    && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

#Install Angular CLI and NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && \
    apt-get -y install nodejs && npm install -g @angular/cli@8 

#Install SonarCLI
ARG SONARQUBE_CLI_VERSION=4.6.2.2472 
ARG SONARQUBE_CLI_ZIP_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARQUBE_CLI_VERSION}-linux.zip

#Install SonarCLI
RUN cd /opt && \
    curl --fail --location --output sonarqube_cli.zip --silent --show-error "${SONARQUBE_CLI_ZIP_URL}" && \
    unzip sonarqube_cli.zip

USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY config-server.yaml /var/jenkins_home/config-server.yaml

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

CMD [ "/bin/bash", "-c", "/usr/local/bin/jenkins.sh; tail -f /dev/null"]

