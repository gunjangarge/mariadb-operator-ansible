#!/bin/bash
OP=mariadb-ns
operator-sdk build --image-build-args "--no-cache" quay.io/gunjangarge/mariadb-operator-ansible:v4
kubectl create namespace $OP
kubectl apply -f deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml -n $OP
kubectl apply -f deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml -n $OP
kubectl apply -f deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml -n $OP
kubectl apply -f deploy/crds/mariadbmonitors.com.gunjangarge.operator.mariadb_crd.yaml -n $OP
kubectl apply -f deploy/service_account.yaml -n $OP
kubectl apply -f deploy/role.yaml -n $OP
kubectl apply -f deploy/role_binding.yaml -n $OP
kubectl apply -f deploy/operator.yaml -n $OP
kubectl apply -f volume.yaml -n $OP
for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml -n $OP
for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml -n $OP
for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbmonitor_cr.yaml -n $OP
for x in {10..1}
do 
    echo -n "$x "; 
    sleep 1;
done
echo
# run only when you need to restore database
# kubectl apply -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml -n $OP
