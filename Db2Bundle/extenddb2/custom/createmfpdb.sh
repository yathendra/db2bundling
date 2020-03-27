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

export MFP_DB_NAME="MFPDB"
export APPCENTER_DB_NAME="APPCRDB"

echo "(*) --> Creating database ${MFP_DB_NAME?} ... "
   if su - ${DB2INSTANCE?} -c "db2 create db ${MFP_DB_NAME?} collate using system pagesize 32768"; then
      su - ${DB2INSTANCE?} -c "db2 activate db ${MFP_DB_NAME?}"
   fi

echo "(*) --> Creating database ${APPCENTER_DB_NAME?} ... "
   if su - ${DB2INSTANCE?} -c "db2 create db ${APPCENTER_DB_NAME?} collate using system pagesize 32768"; then
      su - ${DB2INSTANCE?} -c "db2 activate db ${APPCENTER_DB_NAME?}"
   fi