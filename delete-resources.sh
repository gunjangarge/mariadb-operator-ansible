#!/bin/bash
OP=mariadb-ns
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbmonitor_cr.yaml -n $OP
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbrestore_cr.yaml -n $OP
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadbbackup_cr.yaml -n $OP
kubectl delete -f deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml -n $OP
kubectl delete -f deploy/operator.yaml -n $OP
kubectl delete -f deploy/role_binding.yaml -n $OP
kubectl delete -f deploy/role.yaml -n $OP
kubectl delete -f deploy/service_account.yaml -n $OP
kubectl delete -f deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f deploy/crds/mariadbmonitors.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f volume.yaml
kubectl delete namespace $OP
