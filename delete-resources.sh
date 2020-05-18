#!/bin/bash
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
kubectl delete -f deploy/operator.yaml
kubectl delete -f deploy/role_binding.yaml
kubectl delete -f deploy/role.yaml
kubectl delete -f deploy/service_account.yaml
kubectl delete -f deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f volume.yaml
kubectl delete namespace mariadb-ns
#operator-sdk build quay.io/gunjangarge/mariadb-operator-ansible:v3
