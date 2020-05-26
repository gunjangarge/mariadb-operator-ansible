#!/bin/bash
kubectl delete -f deploy/operator.yaml
kubectl delete -f deploy/role_binding.yaml
kubectl delete -f deploy/role.yaml
kubectl delete -f deploy/service_account.yaml
kubectl delete -f deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
kubectl delete -f deploy/crds/mariadbmonitors.com.gunjangarge.operator.mariadb_crd.yaml
