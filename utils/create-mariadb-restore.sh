#!/bin/bash
OP=$1
db_port=$2
sql_file=$3
[ "${OP}" == "" -o "${db_port}" == "" -o "${sql_file}" == "" ] && echo "Usage: $0 namespace db-port sql-file-restore" && exit
echo "namespace - $OP"
echo "db_port - ${db_port}"
echo "sql file - ${sql_file} <--- Please check that file name is correct"

for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
cat << EOF | kubectl apply -f -
apiVersion: com.gunjangarge.operator.mariadb/v1
kind: MariaDBRestore
metadata:
 name: dbserver-restore
 namespace: ${OP}
spec:
 # Add fields here
 db_image: mariadb:10.4
 mysql_database_to_restore: ${OP}-database-${db_port}
 mysql_user: ${OP}user
 mysql_user_password: ${OP}user123
 mysql_restore_sql_file: "${sql_file}"
EOF

