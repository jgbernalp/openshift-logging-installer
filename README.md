# Installer for OpenShift and LokiStack

## Prepatory steps

- Clone the cluster logging operator repository: [https://github.com/openshift/cluster-logging-operator](https://github.com/openshift/cluster-logging-operator) and checkout the release branch you want to test, e.g. `release-5.6`.
- Clone loki repo [https://github.com/openshift/loki](https://github.com/openshift/loki), the operator resides inside the repo. Checkout the release branch related to an openshift release you want to test, e.g. `openshift/release-5.6`.
- Make sure you can create a s3 bucket using the AWS CLI
- Login to an openshift cluster with the `oc` command

## Install the operators

# Install the cluster logging operator

Checkout the release branch you want to test, e.g. `release-5.7` for the cluster logging operator.

Run `./scripts/install-cluster-logging-operator.sh` script with the following env variables:

- `CLUSTER_LOGGING_OPERATOR_PATH` - path to the cluster logging operator repository

```bash
CLUSTER_LOGGING_OPERATOR_PATH=/Users/openshift/oss/cluster-logging-operator \
./scripts/install-cluster-logging-operator.sh
```

This will create a catalog source and install the operator.

# Install the loki operator

Checkout the release branch you want to test, e.g. `release-5.7` for the cluster logging operator.

Run `./scripts/install-loki-operator.sh` script with the following env variables:

- `LOKI_PATH` - path to loki repository
- `REGISTRY_BASE` - base url of the registry to use for the images, e.g. `quay.io/{your-username}` required for the loki operator to be installed

for example:

```bash
LOKI_PATH=/Users/openshift/oss/loki \
REGISTRY_BASE=quay.io/my-user \
./scripts/install-loki-operator.sh
```

This will and install the loki operator.

## Create the operators instances

# Create the cluster logging instance

Run `scripts/create-cluster-logging-instance.sh`

this will create a testing app that generates logs and a `ClusterLogging` instance.

# Create the lokiStack instance

Run the create instances script with the following env variables:

- `ENABLE_LOG_BASED_ALERTS` - set to `true` to enable log based alerts
- `LOKI_PATH` - path to loki repository
- `S3_BUCKET_NAME` - name of the s3 bucket to use for log storage, add your username so is easily identifiable

```bash
ENABLE_LOG_BASED_ALERTS=true \
LOKI_PATH=/Users/openshift/oss/loki \
S3_BUCKET_NAME=my-user-logs-test \
./scripts/create-loki-instance.sh
```

This will create a `LokiStack` instance, an s3 bucket, configure a secret for it.

If `ENABLE_LOG_BASED_ALERTS` is set to `true` it will also create a ruler in the lokiStack instance and some testing alerting rules for `application` and `infrastructure` tenants.

## Enable the logging view plugin

If you are testing the logging view plugin, it needs to be enabled in the ClusterLogging operator. You can do this by logging in into the console and under installed operators select the ClusterLogging operator, then click on the enable link on the plugin item.
