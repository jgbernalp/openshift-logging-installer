#!/bin/bash

if [ -z "$CLUSTER_LOGGING_OPERATOR_PATH" ]
then
    echo "CLUSTER_LOGGING_OPERATOR_PATH is not defined"
    exit 1
fi

echo "Creating namespaces"
oc create namespace openshift-operators-redhat
oc label ns/openshift-operators-redhat openshift.io/cluster-monitoring=true --overwrite

oc create namespace openshift-logging
oc label ns/openshift-logging openshift.io/cluster-monitoring=true --overwrite

echo "Installing Cluster Logging Operator"
cd $CLUSTER_LOGGING_OPERATOR_PATH
make cluster-logging-catalog-deploy
make cluster-logging-operator-install
