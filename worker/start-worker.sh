#!/bin/bash
set -o errexit
set -o pipefail
# set -o xtrace
display_usage() {
  echo ""
  echo   "OPTIONS:
-p rmi registry port.
-l rmi port to communicate with leader.
-c path to log conf file.
-h JVM Heap options. -Xms128m -Xmx512m by default.
-r Leader hostname"
echo ""
}

if [[ ( $1 == "") ]]
  then
    display_usage
    exit 0
fi
echo "Executing script:$0 $@"
echo ""
while getopts p:c:h:r:l: option
do
case "${option}"
in
p) REGISTRY_PORT=${OPTARG};;
l) RMI_PORT=${OPTARG};;
c) LOG_CONF_PATH=${OPTARG};;
h) HEAP_OPTIONS=${OPTARG};;
r) HOST=${OPTARG};;
esac
done

if [[ -z ${HOST} ]];
  then
    echo "${0}: Specify the rmi server hostname by the -r option."
    exit 1
fi

if [[ -z ${REGISTRY_PORT} ]];
  then
    echo "${0}: Specify the rmi client port by the -p option."
    exit 1
fi

if [[ -z ${RMI_PORT} ]];
  then
    echo "${0}: Specify the rmi client localport by the -l option."
    exit 1
fi

if [[ -z ${LOG_CONF_PATH} ]];
  then
    echo "${0}: Specify the path to the log configuration file by the -c option."
    exit 1
fi

if [[ ! -f ${LOG_CONF_PATH} ]]
  then
    echo "${0}: Not found the specified path: ${LOG_CONF_PATH}."
    exit 1
fi


if [[ -z ${HEAP_OPTIONS} ]]
  then
    HEAP_OPTIONS="-Xms256m -Xmx512m"
    echo "HEAP_OPTIONS weren't specified. ${HEAP_OPTIONS} will be used"
fi

export HEAP=${HEAP_OPTIONS}
export GC_ALGO="-XX:+UseZGC -XX:+ZGenerational"

echo "HEAP OPTIONS: ${HEAP}"
echo ""

CMD="jmeter
-n -s
-i $LOG_CONF_PATH \
-Djava.rmi.server.hostname=$HOST \
-Jserver.rmi.port=$REGISTRY_PORT \
-Jserver.rmi.localport=$RMI_PORT \
-Jserver.rmi.ssl.disable=true \
-Dsun.rmi.log.debug=true \
-Dsun.rmi.server.exceptionTrace=true \
-Dsun.rmi.loader.logLevel=verbose \
-Dsun.rmi.dgc.logLevel=verbose \
-Dsun.rmi.transport.logLevel=verbose \
-Dsun.rmi.transport.tcp.logLevel=verbose"

echo "Starting worker:
${CMD}"

echo ""

${CMD}