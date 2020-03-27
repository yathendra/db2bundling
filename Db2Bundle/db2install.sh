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


# 1. create project if not exists
# 2. create pv (if not exists) and pvc
# 3. export DB_NAMESPACE=db2bundletesting
# 4. export MFP_DB_PVC_NAME=db2pvc
# 5. export DB_USERNAME=db2inst1
# 6. export DB_PASSWORD=db2inst1

# TODO: Make sure the variables are set before running the script

source validatescript.sh

# Terminate the script if the exit value is 1
RC=$?
    if [ $RC -ne 0 ]; then
        exit $RC
    fi

# Note: Default DB is MFPDB . I
# If needed , Export the variable MFPF_DB_NAME in future and make changes in custom/createmfpdb.sh

source extenddb2/extenddb2img.sh

DB2_SECRET_NAME="db2-secret"
DB2_SECRET_NAME_TEMP_FILE=$(mktemp /tmp/db2-secret.yaml)

createDb2Secret()
{
    DB_USERNAME=$1
    DB_PASSWORD=$2

        if oc get secret "${DB2_SECRET_NAME}" > /dev/null 2>&1; then
            echo "[INFO] ${DB2_SECRET_NAME} secret already exists. Deleting and recreating the db2 secret"
            oc delete secret db2-secret
        fi

        DB2INSTANCE_BASE64=$(base64encodeString ${DB_USERNAME})
        DB2INSTANCE_PASSWORD_BASE64=$(base64encodeString ${DB_PASSWORD})


        DB2_SECRET_STRING=""
        DB2_SECRET_STRING="${DB2_SECRET_STRING}apiVersion: v1\n"
        DB2_SECRET_STRING="${DB2_SECRET_STRING}data:\n"
        DB2_SECRET_STRING="${DB2_SECRET_STRING}  DB2INSTANCE: ${DB2INSTANCE_BASE64}\n"
        DB2_SECRET_STRING="${DB2_SECRET_STRING}  DB2INST1_PASSWORD: ${DB2INSTANCE_PASSWORD_BASE64}\n"
        DB2_SECRET_STRING="${DB2_SECRET_STRING}kind: Secret\n"
        DB2_SECRET_STRING="${DB2_SECRET_STRING}metadata:\n"
        DB2_SECRET_STRING="${DB2_SECRET_STRING}  name: db2-secret\n"
        DB2_SECRET_STRING="${DB2_SECRET_STRING}type: Opaque"


        echo "${DB2_SECRET_STRING}" > $DB2_SECRET_NAME_TEMP_FILE

        (exec oc apply -f ${DB2_SECRET_NAME_TEMP_FILE})

        RC=$?

            if [ $RC -ne 0 ]; then
                echo "[ERROR] DB2 database secret creation failure."
                if test -f "${DB2_SECRET_NAME_TEMP_FILE}"; then
                    (rm -f ${DB2_SECRET_NAME_TEMP_FILE})
                fi
                exit $RC
            fi
    
}

setClaimName()
{
    sed -i "s|_PVC_NAME_|${MFP_DB_PVC_NAME}|g" database-deployment.yaml
    echo "[INFO] Claim Name set to ${MFP_DB_PVC_NAME}"
}

setDb2Image()
{
    sed -i "s|_REGISTRY_URL_|${REGISTRY_URL}|g" database-deployment.yaml
    sed -i "s|_DB_IMG_TAG_|${DB_IMG_TAG}|g" database-deployment.yaml
    echo "[INFO] Db2 Image is set to ${REGISTRY_URL}/ibmcom-db2:${DB_IMG_TAG}"
}

setDbName()
{
    echo "[INFO] DB Name will be set to MFPDB by default"
}

base64encodeString()
{
    echo $(printf "%s" "$1" | base64)
}

createSAandSCC()
{
    DB_NAMESPACE=$1
    oc create -f service_account.yaml -n ${DB_NAMESPACE}
    oc create -f scc.yaml -n ${DB_NAMESPACE}
    oc adm policy add-scc-to-user db2database system:serviceaccount:${DB_NAMESPACE}:db2database -n ${DB_NAMESPACE}
}

createDb2Service()
{
    DB_NAMESPACE=$1
    oc create -f database-service.yaml -n ${DB_NAMESPACE}
}

deployDb2()
{
    DB_NAMESPACE=$1
    oc create -f database-deployment.yaml -n ${DB_NAMESPACE}

    RC=$?
    if [ $RC -ne 0 ]; then
        echo "[ERROR] DB2 database deployment failure."
        exit $RC
    else    
        echo "[INFO] Database deployment successful. "
        echo ""
        oc get pods -n ${DB_NAMESPACE}
    fi
}

configDeployment()
{
    # configure PVC for the DB
    setClaimName ${MFP_DB_PVC_NAME}

    # configure Db2 Image
    setDb2Image ${REGISTRY_URL} ${DB_IMG_TAG}

    # configure DB Name
    setDbName ${MFP_DB_NAME}

}

performDeployment(){

    # create Service Account and SCC
    createSAandSCC ${DB_NAMESPACE}

    # create DB2 Service
    createDb2Service ${DB_NAMESPACE}

    # deploy DB2
    deployDb2 ${DB_NAMESPACE}
}

cleanUp (){
  rm -rf ${DB2_SECRET_NAME_TEMP_FILE}
}

#
#      MAIN
#


# Create the Database Secret
createDb2Secret ${DB_USERNAME} ${DB_PASSWORD}

# Configure all deployment artifacts
configDeployment

# Deploy configured artifacts
performDeployment ${DB_NAMESPACE}

cleanUp