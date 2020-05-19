# Mariadb Operator using Ansible

This is mariadb operator using Ansible.

## Supported features:
- [x] Basic Install
- [x] Seamless Upgrades
- [x] Backup and restore
- [ ] Monitoring/Deep Insights

## Setup Instructions

### Create namespace (optional)

   ```console
   $ kubectl create namespace mariadb-ns
   ```

   Note that if you want to create resources under a namespace, you would need to append `-n <namespace>` to `kubectl` command.

### Deploy Mariadb Operator CRD into your cluster

```console
$ kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_mariadbs_crd.yaml
```

### Deploy Service account, roles and operator

```console
$ kubectl apply -f deploy/service_account.yaml
$ kubectl apply -f deploy/role.yaml
$ kubectl apply -f deploy/role_binding.yaml
$ kubectl apply -f deploy/operator.yaml
```

### Verify that the operator is up and running:

```console
$ kubectl get deployment
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
mariadb-operator           1/1     1            1           5m
```

### Create Persistent Volume as below

```yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
   name: mariadb-pv
   labels:
      db: mariadb-data-volume
spec:
   storageClassName: manual
   capacity: 
      storage: 1Gi
   accessModes:
      - ReadWriteOnce
   hostPath:
      path: "/mariadb/data"
```
### Apply PV on cluster

```console
$ kubectl apply -f volume.yaml
```

### Create CR file with below contents

```yaml
---
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDB
metadata:
   name: mariadb-instance
   namespace: mariadb-ns
spec:
   # Add fields here
   size: 1 # in case you are using persistent volume and persistent volume claim, keep size  equal to 1
   mysql_root_password: password
   db_image: mariadb:10.4
   mysql_database: sample
   mysql_user: john
   mysql_user_password: john123
   mysql_conn_service_port: 32000
   external_data_storage_persistent_volume_selector_label:
   db: mariadb-data-volume
   persistent_volume_claim:
   claim_size: 1Gi
   storage_class_name: manual
   access_mode: ReadWriteOnce
```

### Apply CR on cluster

Apply above CR file or below from repository.

```console
$ kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
```

### Verify that the operator is up and running

```console
$ kubectl get deployment
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
mariadb-instance-mariadb   3/3     3            3           3m27s
mariadb-operator           1/1     1            1           7m24s
```

```console
$ kubectl get pods
NAME                                        READY   STATUS    RESTARTS   AGE
mariadb-instance-mariadb-7ccf896b8c-fj5r6   1/1     Running   0          4m21s
mariadb-instance-mariadb-7ccf896b8c-lnl4w   1/1     Running   0          4m21s
mariadb-instance-mariadb-7ccf896b8c-p4q2r   1/1     Running   0          4m21s
mariadb-operator-6bbfc865b5-g92vs           1/1     Running   0          8m22s
```

### Verify that service is up

```console
$ kubectl get svc
NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
kubernetes                 ClusterIP   10.96.0.1       <none>        443/TCP             16m
mariadb-operator-metrics   ClusterIP   10.103.82.227   <none>        8383/TCP,8686/TCP   5m40s
mariadb-service            NodePort    10.105.157.3    <none>        3306:32000/TCP      5m21s
```

### Connect to mysql

```console
$ mysql -h 192.168.1.3 -P 32000 -u john1 -pjohn1
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.5.5-10.4.12-MariaDB-1:10.4.12+maria~bionic mariadb.org binary distribution

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| sample             |
+--------------------+
2 rows in set (0.00 sec)

mysql>
```

## Mariadb database backup

### Create Persistent Volume for backup activities

```yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
    name: mariadb-backup-pv
    labels:
      db: mariadb-databackup-volume
spec:
    storageClassName: manual
    capacity: 
        storage: 1Gi
    accessModes:
        - ReadWriteMany
    hostPath:
        path: "/mariadb/databackup"        
```
### Apply above yaml file or directly from repository

```console
$ kubectl apply -f volume.yaml
```

### Apply Mariadb Backup CRD file into your cluster

```console
$ kubectl apply -f deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
```
### Create Backup CR File as below

```yaml
---
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDBBackup
metadata:
  name: mariadbbackup-instance
  namespace: mariadb-ns # same as mariadb
spec:
  # Add fields here
  db_image: mariadb:10.4
  mysql_database_to_backup: sample
  mysql_user: john
  mysql_user_password: john123
  mariadb_backup_schedule: "*/15 * * * *"
  mariadb_mysqldump_options: "--flush-privileges --skip-lock-tables"
  external_data_storage_mariadb_backup_persistent_volume_selector_label:
    db: mariadb-databackup-volume
  mariadb_backup_persistent_volume_claim:
    claim_size: 111Mi
    storage_class_name: manual
    access_mode: ReadWriteOnce
```
### Apply above CR file or below from repository.

```console
$ kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml
```

### Check resources in cluster

```console
$ kubectl get all -n mariadb-ns
NAME                                            READY   STATUS      RESTARTS   AGE
pod/mariadb-backup-1589807700-5tbm8             0/1     Completed   0          25m
pod/mariadb-backup-1589808600-tc2mk             0/1     Completed   0          10m
pod/mariadb-instance-mariadb-79f94f9767-5ljl6   1/1     Running     0          35m

NAME                      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/mariadb-service   NodePort   10.105.80.158   <none>        3306:32000/TCP   35m

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mariadb-instance-mariadb   1/1     1            1           35m

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/mariadb-instance-mariadb-79f94f9767   1         1         1       35m

NAME                                  COMPLETIONS   DURATION   AGE
job.batch/mariadb-backup-1589807700   1/1           5s         25m
job.batch/mariadb-backup-1589808600   1/1           5s         10m

NAME                           SCHEDULE       SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/mariadb-backup   */15 * * * *   False     0        11m             35m
```
## Mariadb database restore

### Apply Mariadb Restore CRD file into your cluster

```console
$ kubectl apply -f deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
```
### Create Restore CR File as below

```yaml
---
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDBRestore
metadata:
  name: mariadbrestore-instance
  namespace: mariadb-ns
spec:
  # Add fields here
  db_image: mariadb:10.4
  mysql_database_to_restore: sample
  mysql_user: john
  mysql_user_password: john123
  mysql_restore_sql_file: "mysqldump-sample-2020-May-18-063009UTC.sql"
```
### Apply above CR file or below from repository.

```console
$ kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml
```

### Check resources from cluster

```console
$ kubectl get all -n mariadb-ns
NAME                                    READY   STATUS      RESTARTS   AGE
pod/mariadb-backup-1589822400-qn8bs     0/1     Completed   0          108s
pod/mariadb-instance-79f94f9767-lmkp7   1/1     Running     0          3m53s
pod/mariadb-restore-d2qp9               0/1     Completed   0          43s

NAME                      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/mariadb-service   NodePort   10.104.135.24   <none>        3306:32000/TCP   3m51s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mariadb-instance   1/1     1            1           3m53s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/mariadb-instance-79f94f9767   1         1         1       3m53s

NAME                                  COMPLETIONS   DURATION   AGE
job.batch/mariadb-backup-1589822400   1/1           5s         108s
job.batch/mariadb-restore             1/1           4s         43s

NAME                           SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/mariadb-backup   */5 * * * *   False     0        117s            3m53s
```

### Deployment Logs 

```console
$ kubectl logs -f deployment.apps/mariadb-operator
```

## Cleanup

### Clean up the resources:

```console
$ kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml
$ kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml
$ kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
$ kubectl delete -f deploy/operator.yaml
$ kubectl delete -f deploy/role_binding.yaml
$ kubectl delete -f deploy/role.yaml
$ kubectl delete -f deploy/service_account.yaml
$ kubectl delete -f deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl delete -f deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl delete -f deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl delete -f volume.yaml
$ kubectl delete namespace mariadb-ns
```
