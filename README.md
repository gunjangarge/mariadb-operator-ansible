# Mariadb Operator using Ansible
This is mariadb operator using Ansible

## Usage
1. Create namespace (optional)

    ```kubectl create namespace mariadb-ns```
    
    Note that if you want to create resources under a namespace, you would need to append `-n <namespace>` to `kubectl` command.
    
2. Deploy operator CRD into your cluster

    ```
    kubectl apply -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/crds/com.gunjangarge.operator.mariadb_mariadbs_crd.yaml
    ```
    
3. Deploy operator
    
    ```
    kubectl create -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/service_account.yaml
    kubectl create -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/role.yaml
    kubectl create -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/role_binding.yaml
    kubectl create -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/operator.yaml
    ```

4. Verify that the operator is up and running:

    ```
    kubectl get deployment
    ```

5. Create a mariadb operator CR

    Contents of CR file
    ```
    apiVersion: com.gunjangarge.operator.mariadb/v1
    kind: MariaDB
    metadata:
      name: mariadb-instance
    spec:
      # Add fields here
      size: 3
      mysql_root_password: password
      db_image: mariadb:10.4
      mysql_database: sample1
      mysql_user: john1
      mysql_user_password: john1
      mysql_conn_service_port: 32000
    ```
    
    Apply on cluster
    
    ```
    kubectl apply -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
    ```
    
    
## Cleanup
Clean up the resources:

   
    kubectl delete -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/crds/com.gunjangarge.operator.mariadb_v1_mariadb_cr.yaml
    kubectl delete -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/operator.yaml
    kubectl delete -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/role_binding.yaml
    kubectl delete -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/role.yaml
    kubectl delete -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/service_account.yaml
    kubectl delete -f https://github.com/gunjangarge/mariadb-operator-ansible/blob/master/deploy/crds/com.gunjangarge.operator.mariadb_mariadbs_crd.yaml
   
