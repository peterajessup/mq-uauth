#!/bin/bash
oc project mq
set +e
# Remove the runnning queue manager instance (if any)

oc delete QueueManager mq1


# oc delete persistentvolumeclaim data-mq1-ibm-mq-0 data-mq1-ibm-mq-1 data-mq1-ibm-mq-2
set -e
# Create the route and the keystore secret and mqsc configMap
oc apply -f mqAutRoute.yaml
oc apply -f routeMQ1rcvr.yaml
oc create secret tls mq1key --cert=./tls/tls.crt --key=./tls/tls.key
oc create secret generic tls-eris-trust --from-file ./tls/CSQ9.crt
oc create -f mqsc/mqsc.yaml
oc create -f ini/authIni.yaml

set -e
oc create -f mqDeploy.yaml
