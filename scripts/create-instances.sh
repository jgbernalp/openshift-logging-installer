#!/bin/bash

if [ -z "$ENABLE_LOG_BASED_ALERTS" ]
then
  echo "Creating LokiStack instance with ruler"
  oc apply -n openshift-logging -f ./config/loki-stack-with-ruler.yaml

  echo "Creating Loki ruler config"
  oc apply -n openshift-logging -f ./config/loki-ruler-config.yaml

  echo "Creating Loki alerting rules"
  oc apply -n test -f ./config/loki-alert-rules-application.yaml
  oc apply -n openshift-operators-redhat -f ./config/loki-alert-rules-infrastructure.yaml
else
  echo "Creating LokiStack instance"
  oc apply -n openshift-logging -f ./config/loki-stack.yaml
fi

echo "Creating ClusterLogging instance"
oc apply -n openshift-logging -f ./config/cluster-logging.yaml

echo "Creating logs generator app"
oc apply -n test -f ./config/logs-generator-deployment.yaml
