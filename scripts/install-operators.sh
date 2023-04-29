#!/bin/bash

if [ -z "$LOKI_PATH" ]
then
    echo "LOKI_PATH is not defined"
    exit 1
fi

if [ -z "$CLUSTER_LOGGING_OPERATOR_PATH" ]
then
    echo "CLUSTER_LOGGING_OPERATOR_PATH is not defined"
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

oc create namespace test
oc label ns/test openshift.io/cluster-monitoring=true --overwrite

echo "Creating s3 test bucket"
aws s3api create-bucket --bucket $S3_BUCKET_NAME --acl private > /dev/null 2>&1

echo "Deploying s3 secret"
cd "${LOKI_PATH}/operator/hack"
./deploy-aws-storage-secret.sh $S3_BUCKET_NAME

echo "Installing Loki Operator"
cd "${LOKI_PATH}/operator"
make olm-deploy REGISTRY_BASE=$REGISTRY_BASE VARIANT=openshift

echo "Installing Cluster Logging Operator"
cd $CLUSTER_LOGGING_OPERATOR_PATH
make cluster-logging-catalog-deploy
make cluster-logging-operator-install
