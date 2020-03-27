# Running DB2 as Container as Database


## Prerequisites

* Create new-project/namespace
* Create Persistent Volume (if not exists) and Persistent Volume Claim


## Exporting ENV Variables for Building customized db2 docker image and Installing DB2

* export DB\_NAMESPACE = \<NEW_PROJECT>
* export REGISTRY\_URL = \<REGISTRY\_URL>
* export DB\_IMG\_TAG= \<DB\_IMG\_TAG>
* export REGISTRY\_USERNAME = \<REGISTRY\_USERNAME>
* export REGISTRY\_PASSWORD = \<REGISTRY\_PASSWORD>
* export MFP\_DB\_PVC\_NAME = \<PVC_NAME>
* export DB\_USERNAME = \<DB\_INSTANCE_NAME>
* export DB\_PASSWORD = \<DB\_PASSWORD>

>**NOTE**:

>	1. Set `DB_NAMESPACE`  to the new-project that has been created.
> 	2. `REGISTRY_URL` is the registry details where the db2 docker image to be pushed and `DB_IMG_TAG` is the tag name db2 image.  
>
	**Example** : `hyc-mobilefoundation-dev-docker-local.artifactory.swg-devops.com/`**ibmcom-db2**:`db2custom`
	> **Note** :`ibmcom-db2` will be appended to the `REGISTRY_URL` at the run time.
>
> 	3. `REGISTRY_USERNAME` is the username to access the above registry.
> 	4. `REGISTRY_PASSWORD` is the password to access the above registry.
> 	5.	` DB_USERNAME` will be Db2 instance name(**User Defined**) and 	`DB_PASSWORD` will be Db2 instnace password (**User Defined**)
> 	6. By default Database with name `MFPDB` will be created for **Mobile Foundation Server** and `APPCRDB` for **Application center**.
  

## Installation

  In mac os `sh db2install.sh`
  
  In Linux os `./db2install.sh`
  
  On successful deployment , the db2 pod will be in running state .You can connect to the DB on **HOSTNAME** `db2database.${DB_NAMESPACE}.svc` , **PORT** `50000` and with **DBNAME** `MFPDB` for **Mobile Foundation Server** and `APPCRDB` for **Application center**

## Limitations
 
 - Refer to section Limitation under [[https://hub.docker.com/r/ibmcom/db2]()
 