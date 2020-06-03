#!/bin/bash
OP=$1
db_port=$2
[ "${OP}" == "" -o "${db_port}" == "" ] && echo "Usage: $0 namespace db-port" && exit
echo "namespace - ${OP}"
echo "db_port - ${db_port}"

for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
cat << EOF | kubectl delete -f -
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDBBackup
metadata:
 name: dbserver-backup
 namespace: ${OP}
spec:
 # Add fields here
 db_image: mariadb:10.4
 mysql_database_to_backup: ${OP}-database-${db_port}
 mysql_user: ${OP}user
 mysql_user_password: ${OP}user123
 mariadb_backup_schedule: "*/30 * * * *"
 mariadb_mysqldump_options: "--column-statistics=0 --flush-privileges --skip-lock-tables"
 external_data_storage_mariadb_backup_persistent_volume_selector_label:
   db: ${OP}-databackup-volume-${db_port}
 mariadb_backup_persistent_volume_claim:
   claim_size: 500Mi
   storage_class_name: manual
   access_mode: ReadWriteOnce
EOF
for x in {10..1}
do 
   echo -n "$x "; 
   sleep 1;
done
echo

cat << EOF | kubectl delete -f -
apiVersion: v1
kind: PersistentVolume
metadata:
    name: ${OP}-mariadb-backup-pv-${db_port}
    labels:
      db: ${OP}-databackup-volume-${db_port}
spec:
    storageClassName: manual
    capacity:
        storage: 1Gi
    accessModes:
        - ReadWriteMany
    hostPath:
        path: "/${OP}-${db_port}/database/databackup"
EOF