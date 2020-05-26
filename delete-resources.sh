#!/bin/bash
OP=$1
db_port=$2
monitor_port=$3
[ "$OP" == "" -o "$db_port" == "" -o "$monitor_port" == "" ] && echo "Usage: ./$0 namespace db-port monitor-port" && exit
#kubectl delete -f volume.yaml
# for x in {10..1}
# do 
#     echo -n "$x "; 
#     sleep 1;
# done
# echo
#kubectl delete -f- /tmp/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml -n $OP
cat << EOF | kubectl delete -f -
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDB
metadata:
  name: dbserver
  namespace: $OP
spec:
  # Add fields here
  size: 1
  mysql_root_password: password
  db_image: mariadb:10.4
  mysql_database: ${OP}_database
  mysql_user: ${OP}user
  mysql_user_password: ${OP}user123
  mysql_conn_service_port: $db_port
  external_data_storage_persistent_volume_selector_label:
    db: $OP-data-volume
  persistent_volume_claim:
    claim_size: 500Mi
    storage_class_name: manual
    access_mode: ReadWriteOnce  

EOF
# for x in {10..1}
# do 
#     echo -n "$x "; 
#     sleep 1;
# done
# echo
#kubectl delete -f- /tmp/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml -n $OP
cat << EOF | kubectl delete -f -
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDBBackup
metadata:
  name: dbserver-backup
  namespace: $OP
spec:
  # Add fields here
  db_image: mariadb:10.4
  mysql_database_to_backup: ${OP}_database
  mysql_user: ${OP}user
  mysql_user_password: ${OP}user123
  mariadb_backup_schedule: "*/30 * * * *"
  mariadb_mysqldump_options: "--flush-privileges --skip-lock-tables"
  external_data_storage_mariadb_backup_persistent_volume_selector_label:
    db: $OP-databackup-volume
  mariadb_backup_persistent_volume_claim:
    claim_size: 500Mi
    storage_class_name: manual
    access_mode: ReadWriteOnce
EOF
# for x in {10..1}
# do 
#     echo -n "$x "; 
#     sleep 1;
# done
# echo
#kubectl delete -f- /tmp/crds/com.gunjangarge.operator.mariadb_v1_mariadbmonitor_cr.yaml -n $OP
cat << EOF | kubectl delete -f -
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDBMonitor
metadata:
  name: dbserver-monitor
  namespace: $OP
spec:
  # Add fields here
  size: 1
  prometheus_mysqlexportor_image: "prom/mysqld-exporter"
  monitor_service_port: $monitor_port
EOF
# for x in {10..1}
# do 
#     echo -n "$x "; 
#     sleep 1;
# done
# echo
# run only when you need to restore database
# kubectl delete -f- /tmp/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml -n $OP
#cat << EOF | kubectl delete -f -
#apiVersion: com.gunjangarge.operator.mariadb/v1
#kind: MariaDBRestore
#metadata:
#  name: dbserver-restore
#  namespace: $OP
#spec:
#  # Add fields here
#  db_image: mariadb:10.4
#  mysql_database_to_restore: ${OP}_database
#  mysql_user: ${OP}user
#  mysql_user_password: ${OP}user123
#  mysql_restore_sql_file: "mysqldump-sample-2020-May-23-181506UTC.sql"
#EOF
kubectl delete namespace $OP
cat << EOF | kubectl delete -f -
apiVersion: v1
kind: PersistentVolume
metadata:
    name: $OP-mariadb-pv
    labels:
      db: $OP-data-volume
spec:
    storageClassName: manual
    capacity:
        storage: 1Gi
    accessModes:
        - ReadWriteOnce
    hostPath:
        path: "/$OP/database/data"
---
apiVersion: v1
kind: PersistentVolume
metadata:
    name: $OP-mariadb-backup-pv
    labels:
      db: $OP-databackup-volume
spec:
    storageClassName: manual
    capacity:
        storage: 1Gi
    accessModes:
        - ReadWriteMany
    hostPath:
        path: "/$OP/database/databackup"
EOF
