#!/bin/bash

echo "Creating ClusterLogging instance"
oc apply -n openshift-logging -f ./config/cluster-logging.yaml

echo "Creating logs generator app"
oc apply -n test -f ./config/logs-generator-deployment.yaml
