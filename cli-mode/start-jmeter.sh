#!/bin/bash

##echo "(MIGHTY-METER) | Executing $0 $@"

display_usage() {
  echo -e "OPTIONS:
  -a Name of the application under test
  -d Duration of the test in seconds
  -e Environment where the target machine is
  -f JMeter configuration file (*.jmx)
  -i URL used by JMeter to send metrics of the ongoing test
  -j JVM Heap options. -Xms512m -Xmx1g by default
  -k Freq of samples send to Influxdb in seconds
  -n Name of the test
  -o Directory where the result will be stored
  -p Property file
  -r RAMP-UP period
  -t Number of threads
  -v Version of the application under test
  "
}

if [[ ( $1 == "") ]]
  then
    display_usage
    exit 0
fi

main() {


while getopts a:b:d:e:f:i:j:k:n:r:t:v:p: option
do
case "${option}"
in
a) APP=${OPTARG};;
b) INFLUX_TOKEN=${OPTARG};;
d) DURATION=${OPTARG};;
e) ENV=${OPTARG};;
f) FILE_JMX=${OPTARG};;
i) INFLUX_URL=${OPTARG};;
j) HEAP_OPTIONS="${OPTARG}";;
k) FREQ_SAMPLES=${OPTARG};;
n) TEST_NAME=${OPTARG};;
r) RAMP_UP_PERIOD=${OPTARG};;
t) NUM_OF_THREADS=${OPTARG};;
v) VERSION=${OPTARG};;
p) FILE_PROP=${OPTARG};;
esac
done

assertNotEmpty () {
  if [[ -z $2 ]]
    then
      echo "$1"
      display_usage
      exit 1
  fi
}

assertNotEmpty "freq of samples required" ${FREQ_SAMPLES}
assertNotEmpty "app name required" ${APP}
assertNotEmpty "properties file required" ${FILE_PROP}
assertNotEmpty "duration required" ${DURATION}
assertNotEmpty "env required" ${ENV}
assertNotEmpty "jmx file required" ${FILE_JMX}
assertNotEmpty "influxdb url required" ${INFLUX_URL}
assertNotEmpty "influxdb token required" ${INFLUX_TOKEN}
assertNotEmpty "name test required" ${TEST_NAME}
assertNotEmpty "number of threads required" ${NUM_OF_THREADS}
assertNotEmpty "ramp-up period required" ${RAMP_UP_PERIOD}

if [[ ! -f ${FILE_JMX} ]]
  then
    echo "file ${FILE_JMX} not found"
    display_usage
    exit 1
fi

if [[ ! -f ${FILE_PROP} ]]
  then
    echo "${FILE_PROP} not found"
    display_usage
    exit 1
fi

export HEAP="${HEAP_OPTIONS}"

CONCURRENT_USERS=$NUM_OF_THREADS
DATE=$(date +"%F-%T")
DATE_FORMATTED="${DATE//:/_}"
DIR=${VOLUME_REPORTS}/${APP}/${TEST_NAME}/${CONCURRENT_USERS}-cu/${DATE_FORMATTED}
RESULT_FILE=${DIR}/result.jtl
REPORT_DIR=${DIR}/report

mkdir -p  ${REPORT_DIR}

CMD="jmeter -n -e \
-t ${FILE_JMX} \
-l ${RESULT_FILE} \
-i /etc/jmeter/log-conf.xml \
-q ${FILE_PROP} \
-o ${REPORT_DIR} \
-Jclient.tries=10 \
-Jclient.retries_delay=5000 \
-Jclient.continue_on_fail=false  \
-JENV=${ENV} \
-JAPP=${APP} \
-JINFLUX_URL=${INFLUX_URL} \
-JINFLUX_TOKEN=${INFLUX_TOKEN} \
-Jsubresults.disable_renaming=true \
-JCONCURRENT_USERS=${CONCURRENT_USERS} \
-JTEST_NAME=${TEST_NAME} \
-JVERSION=${VERSION} \
-JNUM_OF_THREADS=${NUM_OF_THREADS} \
-JRAMP_UP_PERIOD=${RAMP_UP_PERIOD} \
-JDURATION=${DURATION} \
-Jmode=StrippedAsynch \
-Jasynch.batch.queue.size=10000 \
-Jbackend_influxdb.send_interval=${FREQ_SAMPLES}"

echo "Running the test plan..."
${CMD}

#if report is not generated because of an error, remove the directory
if [[ ! -f ${RESULT_FILE} ]]
  then
    rm -rf ${DIR}
fi

}

main "$@"
