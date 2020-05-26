#!/bin/bash
operator-sdk build --image-build-args "--no-cache" quay.io/gunjangarge/mariadb-operator-ansible:v4
kubectl apply -f deploy/crds/mariadbs.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f deploy/crds/mariadbbackups.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f deploy/crds/mariadbrestores.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f deploy/crds/mariadbmonitors.com.gunjangarge.operator.mariadb_crd.yaml
kubectl apply -f deploy/service_account.yaml
kubectl apply -f deploy/role.yaml
kubectl apply -f deploy/role_binding.yaml
kubectl apply -f deploy/operator.yaml
