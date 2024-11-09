#!/bin/bash

mm-cli-mode-run-tests \
--duration 20 \
--num-threads 10 \
--ramp-up 1 \
--env dev \
--jmx-file ./example.jmx \
--props-file ./example.properties \
--app myapp \
--app-version 1.0.0 \
--test-name anotherTest