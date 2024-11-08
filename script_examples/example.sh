#this set up is for running MightyMeter in your local machine
#use your IP instead
LEADER_HOST="192.168.1.64"
WORKERS_HOSTS="192.168.1.64"

mm-leader-run-tests \
--duration 120 \
--num-threads 30 \
--ramp-up 1 \
--leader-host ${LEADER_HOST} \
--worker-hosts ${WORKERS_HOSTS} \
--env pro \
--jmx-file ./example.jmx \
--props-file ./example.properties \
--app myapp \
--app-version 2.0.0 \
--test-name mytest