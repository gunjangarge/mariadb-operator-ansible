#!/bin/bash
OP=$1
db_port=$2
cluster_enabled=$3
first_node=$4
server_name=$5
[ "${server_name}" == "" -o "${cluster_enabled}" == "" -o "${OP}" == "" -o "${db_port}" == "" -o "${first_node}" == "" ] && echo "Usage: $0 namespace db-port cluster_enabled(true/false) first_node(true/false) servername" && exit
[ "${first_node}" != true -a "${first_node}" != false ] && echo "first node should be true/false" && exit
[ "${cluster_enabled}" != true -a "${cluster_enabled}" != false ] && echo "cluster enabled should be true/false" && exit
echo "namespace - ${OP}"
echo "db_port - ${db_port}"
echo "cluster enabled - ${cluster_enabled}"
echo "first node - ${first_node}"
echo "server name - ${server_name}"
for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
mkdir -p /mariadb/${OP}-${db_port}/database/data 
kubectl create namespace ${OP}
#kubectl apply -f volume.yaml
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
    name: ${OP}-mariadb-pv-${db_port}
    labels:
      db: ${OP}-data-volume-${db_port}
spec:
    storageClassName: manual
    capacity:
        storage: 1Gi
    accessModes:
        - ReadWriteOnce
    hostPath:
        path: "/mariadb/${OP}-${db_port}/database/data"
    nodeAffinity:
      required:
        nodeSelectorTerms:
          - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
              - ${server_name}
EOF

for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
#kubectl apply -f- /tmp/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml -n ${OP}
cat << EOF | kubectl apply -f -
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDB
metadata:
  name: dbserver-${db_port}
  namespace: ${OP}
spec:
  # Add fields here
  size: 1
  db_image: mariadb:10.4
  cluster:
    enabled: ${cluster_enabled}
    first_node: ${first_node}
    server_name: ${server_name}
  mysql_root_password: password
  mysql_database: ${OP}-database-${db_port}
  mysql_user: ${OP}user
  mysql_user_password: ${OP}user123
  mysql_conn_service_port: ${db_port}
  external_storage:
    enabled: true
    persistent_volume_selector_label:
      db: ${OP}-data-volume-${db_port}
    persistent_volume_claim:
      claim_size: 500Mi
      storage_class_name: manual
      access_mode: ReadWriteOnce  

EOF
