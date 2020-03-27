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

declare -a envListArr=("REGISTRY_USERNAME"
                "REGISTRY_PASSWORD"
                "REGISTRY_URL"
                "DB_IMG_TAG"
                "DB_NAMESPACE"
                "MFP_DB_PVC_NAME"
                "DB_USERNAME"
                "DB_PASSWORD")

for i in "${envListArr[@]}"
do
    if [ -n "${!i}" ]; then
      echo "$i set to value: ${!i}"
    else
      echo "[ERROR] : Variable $i is not set"
      exit 1
    fi
done

echo "[INFO] All Mandatory env variables are set . You are good to go"