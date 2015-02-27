FROM ubuntu

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

RUN apt-get update && apt-get install -y wget screen rsync zip
RUN wget -q https://raw.githubusercontent.com/jduckles/minecraft-server-manager/master/installers/debian.sh -O /tmp/msm && bash /tmp/msm
