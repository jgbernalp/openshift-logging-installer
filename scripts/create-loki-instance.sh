#!/bin/bash

if [ -n "${ENABLE_LOG_BASED_ALERTS}" ]
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

oc create namespace test
oc label ns/test openshift.io/cluster-monitoring=true --overwrite

echo "Creating s3 test bucket"
aws s3api create-bucket --bucket $S3_BUCKET_NAME --acl private > /dev/null 2>&1

echo "Deploying s3 secret"
cd "${LOKI_PATH}/operator/hack"
./deploy-aws-storage-secret.sh $S3_BUCKET_NAME
cd -