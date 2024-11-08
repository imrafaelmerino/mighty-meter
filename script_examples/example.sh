#this set up is for running JIG in your local machine
#use your IP instead
COORDINATOR_HOST="192.168.1.64"
EXECUTORS_HOSTS="192.168.1.64"

mm-leader-run-tests \
--duration 120 \
--num-threads 30 \
--ramp-up 1 \
--leader-host ${COORDINATOR_HOST} \
--worker-hosts ${EXECUTORS_HOSTS} \
--env pro \
--jmx-file ./example.jmx \
--props-file ./example.properties \
--app myapp \
--app-version 2.0.0 \
--test-name mytest