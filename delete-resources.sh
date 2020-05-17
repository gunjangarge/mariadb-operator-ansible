#!/bin/bash
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
kubectl delete -f deploy/operator.yaml
kubectl delete -f deploy/role_binding.yaml
kubectl delete -f deploy/role.yaml
kubectl delete -f deploy/service_account.yaml
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_mariadbs_crd.yaml 
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_mariadbbackups_crd.yaml
kubectl delete -f volume.yaml
kubectl delete namespace mariadb-ns
operator-sdk build quay.io/gunjangarge/mariadb-operator-ansible:v3
