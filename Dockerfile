ARG version=4.10-6-jdk17-preview
FROM jenkins/agent:$version

ARG version
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="$version"

USER root

COPY ./jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
RUN  apt-get -y update && apt-get -y install curl

RUN curl -sSL https://get.daocloud.io/docker | sh

RUN apt-get update &&  apt-get install -y apt-transport-https
RUN curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg |  apt-key add -
RUN echo "deb http://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 307EA071
RUN gpg --export --armor 307EA071 | apt-key add -
RUN apt-get -y update
RUN apt-get install -y kubectl
RUN apt-get install -y python2.7
RUN apt-get install -y yarn
RUN apt-get install -y cmake build-essential

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
