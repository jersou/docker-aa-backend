FROM debian:jessie


RUN echo "# jessie-backports" >> /etc/apt/sources.list \
 && echo "deb http://ftp.fr.debian.org/debian/ jessie-backports main" >> /etc/apt/sources.list \
 && echo "deb-src http://ftp.fr.debian.org/debian/ jessie-backports main" >> /etc/apt/sources.list

RUN apt-get update && apt-get -y upgrade && apt-get install -y apt-utils curl


RUN apt-get install -y openjdk-8-jre openjdk-8-doc ca-certificates-java="20161107~bpo8+1"

RUN apt-get install -y tomcat8 aptitude libreoffice bsd-mailx cron ethtool mysql-common ndiff nmap exim4 htop iftop \
 init-system-helpers iotop lsb-release ntp sudo tomcat8-admin unoconv unzip zip iso-codes locales logrotate lp-solve \
 odbcinst poppler-data postgis postgresql-9.4 postgresql-9.4-postgis-2.1 postgresql-9.4-postgis-2.1-scripts


# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential software-properties-common byobu curl git htop man unzip vim wget socat && \
  rm -rf /var/lib/apt/lists/*

# Install Oracle Java.

# auto validate license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# update repos
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update

# install java
RUN apt-get install oracle-java8-installer -y
RUN apt-get clean
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ENV MAVEN_VERSION 3.3.9

RUN mkdir -p /usr/share/maven \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven


# encoding
RUN apt-get install locales && echo 'fr_FR.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen fr_FR.UTF-8  && update-locale LANG=fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
