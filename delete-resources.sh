#!/bin/bash
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
kubectl delete -f deploy/operator.yaml
kubectl delete -f deploy/role_binding.yaml
kubectl delete -f deploy/role.yaml
kubectl delete -f deploy/service_account.yaml
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_mariadbs_crd.yaml 
kubectl delete -f volume.yaml
operator-sdk build quay.io/gunjangarge/mariadb-operator-ansible:v2