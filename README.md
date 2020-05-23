# Mariadb Operator using Ansible

This is mariadb operator using Ansible.

## Supported features:
- [x] Basic Install
- [x] Seamless Upgrades
- [x] Backup and restore
- [x] Monitoring

## TL;DR

### Create Mariadb, Backup cronjob, Restore job and Monitor resource

```console
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbmonitors.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/service_account.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/role.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/role_binding.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/operator.yaml
kubectl create namespace mariadb-ns
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/volume.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml
# Run only when you need to monitor database
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/prometheus-monitoring/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/prometheus-monitoring/servicemonitor.yaml
kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbmonitor_cr.yaml
# Run only when you need to restore database
# kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml

```

### Cleanup everything

[Cleanup](https://github.com/gunjangarge/mariadb-operator-ansible#cleanup) - clean up everything

## Setup Instructions

### Create namespace (optional)

```console
# kubectl create namespace mariadb-ns
namespace/mariadb-ns created
```

Note that if you want to create resources under a namespace, you would need to append `-n <namespace>` to `kubectl` command.

### Deploy all Mariadb Operator CRDs into your cluster

```console
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbmonitors.com.gunjangarge.operator.mariadb_crd.yaml
```
### Verify all CRDs are deployed
```console
$ kubectl get crds
NAME                                               CREATED AT
mariadbbackups.com.gunjangarge.operator.mariadb    2020-05-23T14:33:38Z
mariadbmonitors.com.gunjangarge.operator.mariadb   2020-05-23T14:34:13Z
mariadbrestores.com.gunjangarge.operator.mariadb   2020-05-23T14:33:59Z
mariadbs.com.gunjangarge.operator.mariadb          2020-05-23T14:33:17Z
```

### Deploy Service account, roles and operator

```console
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/service_account.yaml
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/role.yaml
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/role_binding.yaml
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/operator.yaml
```

### Verify that the operator is up and running:

```console
$ kubectl get deployment
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
mariadb-operator           1/1     1            1           5m
```

### Create Persistent Volume for data and data backup as below

```console
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/volume.yaml
```

### Apply Mariadb CR on cluster

```console
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
```

### Verify that the operator is up and running

```console
$ kubectl get deployment -n mariadb-ns
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
mariadb   1/1     1            1           26s
```

```console
$ kubectl get pods -n mariadb-ns
NAME                       READY   STATUS    RESTARTS   AGE
mariadb-84d4f8b5dd-dqlg9   1/1     Running   0          77s
```

### Verify that service is up

```console
$ kubectl get svc -n mariadb-ns
NAME              TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
mariadb-service   NodePort   10.106.98.31   <none>        3306:32000/TCP   110s
```

### Connect to mysql

```console
$ mysql -h 10.0.0.7 -P 32000 -u john -pjohn123
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.5.5-10.4.13-MariaDB-1:10.4.13+maria~bionic mariadb.org binary distribution

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

### Apply Mariadb Backup CR file

```console
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml
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

```
### Apply Mariadb Restore CR file

```console
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml
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

### Check Mariadb Operator deployment logs 

```console
$ kubectl logs -f deployment.apps/mariadb-operator
```

## Mariadb Monitoring using Prometheus 

##### It is assumed that Prometheus is already deployed in k8s cluster.

### Deploy Prometheus Server and ServiceMonitor
```console
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/prometheus-monitoring/prometheus.yaml
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/prometheus-monitoring/servicemonitor.yaml
```

### Apply MariaDB Monitor CR file

```console
$ kubectl apply -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbmonitor_cr.yaml
```

### Check resources from cluster
```console
$ kubectl get all -n mariadb-ns
NAME                                   READY   STATUS      RESTARTS   AGE
pod/mariadb-84d4f8b5dd-8n2rf           1/1     Running     0          3h20m
pod/mariadb-backup-1590237900-ns9zs    0/1     Completed   0          37m
pod/mariadb-backup-1590238800-fmsr6    0/1     Completed   0          22m
pod/mariadb-backup-1590239700-2wfjx    0/1     Completed   0          7m47s
pod/mariadb-monitor-7dfb4d664f-mvs2h   1/1     Running     0          3h20m

NAME                              TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/mariadb-monitor-service   NodePort   10.104.94.196   <none>        9104:32500/TCP   3h20m
service/mariadb-service           NodePort   10.99.21.113    <none>        3306:32000/TCP   3h20m

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mariadb           1/1     1            1           3h20m
deployment.apps/mariadb-monitor   1/1     1            1           3h20m

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/mariadb-84d4f8b5dd           1         1         1       3h20m
replicaset.apps/mariadb-monitor-7dfb4d664f   1         1         1       3h20m

NAME                                  COMPLETIONS   DURATION   AGE
job.batch/mariadb-backup-1590237900   1/1           9s         37m
job.batch/mariadb-backup-1590238800   1/1           6s         22m
job.batch/mariadb-backup-1590239700   1/1           6s         7m47s

NAME                           SCHEDULE       SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/mariadb-backup   */15 * * * *   False     0        7m49s           3h20m
```

### Verify that metrics are being captured
Browse to http://mariadb-monitor-service_ip:mariadb-service-port/metrics

## Cleanup

### Clean up the resources:

```console
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbmonitor_cr.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/operator.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/role_binding.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/role.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/service_account.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbmonitors.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
$ kubectl delete -f https://raw.githubusercontent.com/gunjangarge/mariadb-operator-ansible/master/volume.yaml
$ kubectl delete namespace mariadb-ns
```
