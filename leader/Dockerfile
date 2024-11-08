FROM mighty-jmeter:1.0.0
ARG VOLUME_REPORTS
ARG VOLUME_CONF
ARG VOLUME_LOGS

RUN mkdir -p ${VOLUME_LOGS}
RUN mkdir -p ${VOLUME_REPORTS}
RUN mkdir -p ${VOLUME_CONF}/jmx
RUN mkdir -p ${VOLUME_CONF}/props
RUN mkdir -p /etc/jmeter/scripts
RUN mkdir -p /etc/jmeter/conf/props

COPY start-leader.sh  /etc/jmeter/scripts/start-leader.sh
RUN chmod +x /etc/jmeter/scripts/*

COPY log4j2-leader.xml /etc/jmeter/log-conf.xml

ENV PATH $PATH:/etc/jmeter/scripts
ENV VOLUME_REPORTS ${VOLUME_REPORTS}
ENTRYPOINT ["/etc/jmeter/scripts/start-leader.sh"]

