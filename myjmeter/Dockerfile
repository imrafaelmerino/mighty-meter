FROM openjdk:21-oraclelinux8
ARG JMETER_DOWNLOAD_URL

RUN mkdir -p /tmp/dependencies
RUN curl -L ${JMETER_DOWNLOAD_URL} > /tmp/dependencies/apache-jmeter.tgz
RUN mkdir -p /opt
RUN tar -xzf /tmp/dependencies/apache-jmeter.tgz -C /opt && mv /opt/apache-jmeter* /opt/apache-jmeter
RUN rm -rf /tmp/dependencies
COPY ext-libraries/* /opt/apache-jmeter/lib/ext/
COPY lib-libraries/* /opt/apache-jmeter/lib/

ENV PATH $PATH:/opt/apache-jmeter/bin
