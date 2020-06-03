#!/bin/bash
OP=$1
monitor_port=$2
[ "$OP" == "" -o "${monitor_port}" == ""  ] && echo "Usage: $0 namespace monitor-port" && exit
echo "namespace - ${OP}"
echo "monitor_port - ${monitor_port}"

for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
##kubectl apply -f- /tmp/crds/com.gunjangarge.operator.mariadb_v1_mariadbmonitor_cr.yaml -n ${OP}
cat << EOF | kubectl apply -f -
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDBMonitor
metadata:
 name: dbserver-monitor
 namespace: ${OP}
spec:
 # Add fields here
 size: 1
 prometheus_mysqlexportor_image: "prom/mysqld-exporter"
 monitor_service_port: ${monitor_port}
EOF