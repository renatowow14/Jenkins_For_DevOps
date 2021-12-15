FROM debian:latest

ENV NODE_VERSION v16.4.2

LABEL maintainer="Renato Gomes <renatogomessilverio@gmail.com>"

SHELL ["/bin/bash", "-c"]

USER root 
ARG user=user
ARG group=user
ARG uid=1000
ARG gid=1000

ENV JENKINS_HOME /APP

RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN set -e \
    export DEBIAN_FRONTEND=noninteractive \
    dpkg-divert --local --rename --add /sbin/initctl  && \
    (echo "Yes, do as I say!" | apt-get remove --force-yes login) &&  \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && apt-get -y install procps htop vim curl git wget net-tools sudo figlet && \
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && \
    apt-get -y install nodejs && npm install -g @angular/cli@8 && rm -rf /var/lib/apt/lists/* && \
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash  && \
    . /root/.nvm/nvm.sh 

RUN mkdir -p /APP && mkdir -p /STORAGE \
    echo 'figlet -t "Lapig Docker App-Base"' >> ~/.bashrc && \
    echo "exit" >> /root/.bashrc && \
    cd /APP && git clone https://github.com/renatowow14/plataform-base.git && \
    cp -rvp /APP/plataform-base/src /APP && \
    rm -rfv plataform-base/ && \
    rm -rf /var/lib/apt/lists/*

COPY Monitora.sh /APP

RUN chmod +x /APP/Monitora.sh

WORKDIR /APP/src/server

CMD [ "/bin/bash", "-c", "/APP/src/server/prod-start.sh; tail -f /dev/null"]

ENTRYPOINT [ "/APP/Monitora.sh"]
