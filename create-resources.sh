#!/bin/bash
kubectl apply -f deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f deploy/service_account.yaml
kubectl apply -f deploy/role.yaml
kubectl apply -f deploy/role_binding.yaml
kubectl apply -f deploy/operator.yaml
kubectl create namespace mariadb-ns
kubectl apply -f volume.yaml
for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml
# run only when you need to restore database
# kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml
