FROM jenkins/jenkins:lts

#Disable SetupWizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false -Duser.timezone=America/Sao_Paulo
#Define config for Jenkins Configuration as Code Plugin
ENV CASC_JENKINS_CONFIG /var/jenkins_home/config-server.yaml
LABEL Renato-Gomes-Silvério <renatogomessilverio@gmail>

SHELL ["/bin/bash", "-c"]

USER root 

#Install docker and debug tools
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
apt-get -y install docker-ce htop vim wget net-tools sudo

COPY config-server.yaml /var/jenkins_home/config-server.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN chown -R jenkins:jenkins /var/jenkins_home/config-server.yaml

USER jenkins

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt 

CMD [ "/bin/bash", "-c", "/usr/local/bin/jenkins.sh; tail -f /dev/null"]

