#!/bin/bash
kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_mariadbs_crd.yaml
kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_mariadbbackups_crd.yaml
kubectl apply -f deploy/service_account.yaml
kubectl apply -f deploy/role.yaml
kubectl apply -f deploy/role_binding.yaml
kubectl apply -f deploy/operator.yaml
kubectl create namespace mariadb-ns
kubectl apply -f volume.yaml
#sleep 30
for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml
