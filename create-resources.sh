#!/bin/bash
kubectl create -f deploy/crds/com.gunjangarge.operator.mariadb_mariadbs_crd.yaml
kubectl create -f deploy/service_account.yaml
kubectl create -f deploy/role.yaml
kubectl create -f deploy/role_binding.yaml
kubectl create -f deploy/operator.yaml
kubectl create -f volume.yaml
#sleep 30
for x in {30..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
kubectl create -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml