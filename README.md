# Mariadb Operator using Ansible

This is mariadb operator using Ansible

## Usage

1. Create namespace (optional)

   ```$ kubectl create namespace mariadb-ns```

   Note that if you want to create resources under a namespace, you would need to append `-n <namespace>` to `kubectl` command.

2. Deploy operator CRD into your cluster

   ```
   kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_mariadbs_crd.yaml
   
   ```

3. Deploy operator

   ```
   $ kubectl create -f deploy/service_account.yaml
   $ kubectl create -f deploy/role.yaml
   $ kubectl create -f deploy/role_binding.yaml
   $ kubectl create -f deploy/operator.yaml
   ```

4. Verify that the operator is up and running:

   ```
   $ kubectl get deployment
   NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
   mariadb-operator           1/1     1            1           5m

   ```

5. Create a mariadb operator CR

   5.1 Create CR file with below contents

   ```
   apiVersion: com.gunjangarge.operator.mariadb/v1
   kind: MariaDB
   metadata:
     name: mariadb-instance
   spec:
     # Add fields here
     size: 1 # in case you are using persistent volume and persistent volume claim, keep size  equal to 1
     mysql_root_password: password
     db_image: mariadb:10.4
     mysql_database: sample1
     mysql_user: john1
     mysql_user_password: john1
     mysql_conn_service_port: 32000
     external_data_storage_persistent_volume_selector_label:
      db: mariadb-data-volume
   ```

   5.2 Create Persistent Volume as below

   ```
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
   5.3 Apply PV on cluster

   ```  
   $ kubectl apply -f volume.yaml
   ```

   5.4 Apply CR on cluster

   ```
   $ kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml

   ```

6. Verify that the operator is up and running

   ```
   $ kubectl get deployment
   NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
   mariadb-instance-mariadb   3/3     3            3           3m27s
   mariadb-operator           1/1     1            1           7m24s

   ```

   ```
   $ kubectl get pods
   NAME                                        READY   STATUS    RESTARTS   AGE
   mariadb-instance-mariadb-7ccf896b8c-fj5r6   1/1     Running   0          4m21s
   mariadb-instance-mariadb-7ccf896b8c-lnl4w   1/1     Running   0          4m21s
   mariadb-instance-mariadb-7ccf896b8c-p4q2r   1/1     Running   0          4m21s
   mariadb-operator-6bbfc865b5-g92vs           1/1     Running   0          8m22s

   ```

7. Verify that service is up

   ```
   $ kubectl get svc
   NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
   kubernetes                 ClusterIP   10.96.0.1       <none>        443/TCP             16m
   mariadb-operator-metrics   ClusterIP   10.103.82.227   <none>        8383/TCP,8686/TCP   5m40s
   mariadb-service            NodePort    10.105.157.3    <none>        3306:32000/TCP      5m21s
   ```

8. Connect to mysql

   ```
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
   | sample1            |
   +--------------------+
   2 rows in set (0.00 sec)

   mysql>


   ```

## Cleanup

Clean up the resources:

   ```
    $ kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
    $ kubectl delete -f deploy/operator.yaml
    $ kubectl delete -f deploy/role_binding.yaml
    $ kubectl delete -f deploy/role.yaml
    $ kubectl delete -f deploy/service_account.yaml
    $ kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_mariadbs_crd.yaml
    $ kubectl delete -f volume.yaml

   ```
