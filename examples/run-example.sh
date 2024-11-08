#this set up is for running MightyMeter in your local machine
#for this scenario, use your IP instead of a host name for both the leader
#and worker
LEADER_HOST="192.168.1.64"
WORKERS_HOSTS="192.168.1.64"

mm-leader-run-tests \
--duration 20 \
--num-threads 10 \
--ramp-up 1 \
--leader-host ${LEADER_HOST} \
--worker-hosts ${WORKERS_HOSTS} \
--env dev \
--jmx-file ./example.jmx \
--props-file ./example.properties \
--app myapp \
--app-version 1.0.0 \
--test-name anotherTest