#!/bin/bash

if [ -z "$LOKI_PATH" ]
then
    echo "LOKI_PATH is not defined"
    exit 1
fi

if [ -z "$S3_BUCKET_NAME" ]
then
    echo "S3_BUCKET_NAME is not defined"
    exit 1
fi

if [ -z "$REGISTRY_BASE" ]
then
    echo "REGISTRY_BASE is not defined"
    exit 1
fi

echo "Creating namespaces"
oc create namespace openshift-operators-redhat
oc label ns/openshift-operators-redhat openshift.io/cluster-monitoring=true --overwrite

oc create namespace openshift-logging
oc label ns/openshift-logging openshift.io/cluster-monitoring=true --overwrite

echo "Installing Loki Operator"
cd "${LOKI_PATH}/operator"
make olm-deploy REGISTRY_BASE=$REGISTRY_BASE VARIANT=openshift

