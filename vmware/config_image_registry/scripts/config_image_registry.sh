#!/bin/bash

###
# Check if boostrap is completed
###
KUBECONFIG_FILE=/installer/auth/kubeconfig

#TODO add code for production NFS image registry
#Following code is for test.

NFS_IP=$1
NFS_PATH=$2

sudo KUBECONFIG=${KUBECONFIG_FILE} /usr/local/bin/oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"storage":{"emptyDir":{}}}}'

