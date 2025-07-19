FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8

ENV OOZIE_VERSION=4.3.1
ENV OOZIE_HOME=/opt/oozie
ENV PATH=$PATH:$OOZIE_HOME/bin

USER root

RUN apt-get update && apt-get install -y wget unzip openjdk-8-jdk && \
    apt-get clean && \
    wget https://downloads.apache.org/oozie/${OOZIE_VERSION}/oozie-${OOZIE_VERSION}.tar.gz && \
    tar -xvzf oozie-${OOZIE_VERSION}.tar.gz && \
    mv oozie-${OOZIE_VERSION} $OOZIE_HOME && \
    rm oozie-${OOZIE_VERSION}.tar.gz

WORKDIR $OOZIE_HOME
CMD ["bash"]
