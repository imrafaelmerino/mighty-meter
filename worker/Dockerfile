ARG MIGHTY_METER_VERSION
FROM mighty-jmeter:${MIGHTY_METER_VERSION}

ARG VOLUME_LOGS
RUN mkdir -p ${VOLUME_LOGS}
RUN mkdir -p /etc/jmeter/scripts
COPY start-worker.sh  /etc/jmeter/scripts/start-worker.sh
COPY log4j2-worker.xml /etc/jmeter/log-conf.xml
RUN chmod +x /etc/jmeter/scripts/*

ENV PATH $PATH:/etc/jmeter/scripts
ENTRYPOINT ["start-worker.sh","-c","/etc/jmeter/log-conf.xml"]