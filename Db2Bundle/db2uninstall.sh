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

DB2_SECRET_NAME_TEMP_FILE="/tmp/db2-secret.yaml"

cleanUp (){
    rm -rf ${DB2_SECRET_NAME_TEMP_FILE}
}

cleanUp

oc adm policy remove-scc-from-user db2database system:serviceaccount:$DB_NAMESPACE:db2database -n $DB_NAMESPACE

oc delete scc db2database -n $DB_NAMESPACE

oc delete sa db2database -n $DB_NAMESPACE

oc delete svc db2database -n $DB_NAMESPACE

oc delete deployment db2database -n $DB_NAMESPACE


