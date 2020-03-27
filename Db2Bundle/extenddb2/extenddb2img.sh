#!/bin/bash
# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2020. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# *****************************************************************

# 1. export REGISTRY_USERNAME=AVN0K5744@nomail.relay.ibm.com
# 2. export REGISTRY_PASSWORD=mfp1cpv8
# 3. export REGISTRY_URL=hyc-mobilefoundation-dev-docker-local.artifactory.swg-devops.com
# 4. export DB_IMG_TAG=db2custom
# 5. export DB_NAMESPACE=db2bundletesting

# TODO: Make sure the variables are set before running the script


buildAndPushDb2Image()
{
    echo "[INFO] Registry URL is set to ${REGISTRY_URL}"

    echo "[INFO] DB image tag is set to ${DB_IMG_TAG}"

    echo "[INFO] Building Customized DB2 Docker Image"

    docker build -t ${REGISTRY_URL}/ibmcom-db2:${DB_IMG_TAG} extenddb2/.

    echo "[INFO] Docker Logging .."

    docker login  ${REGISTRY_URL} -u ${REGISTRY_USERNAME} -p ${REGISTRY_PASSWORD}

    echo "[INFO] Pushing Db2 Docker Image "

    docker push ${REGISTRY_URL}/ibmcom-db2:${DB_IMG_TAG}
}

createDb2DockerSecret()
{
    if oc get secret "db2-docker-registry-secret" > /dev/null 2>&1; then
            echo "[INFO] db2-docker-registry-secret secret exists. Deleting and recreating the db2-docker-registry-secret secret"
            oc delete secret db2-docker-registry-secret
    fi

    kubectl create secret docker-registry -n ${DB_NAMESPACE} db2-docker-registry-secret --docker-server=${REGISTRY_URL} --docker-username=${REGISTRY_USERNAME} --docker-password=${REGISTRY_PASSWORD}
}

#
#      MAIN
#


 buildAndPushDb2Image

 createDb2DockerSecret