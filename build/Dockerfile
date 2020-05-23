FROM quay.io/operator-framework/ansible-operator:latest

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
 && chmod -R ug+rwx ${HOME}/.ansible

COPY watches.yaml ${HOME}/watches.yaml

COPY roles/ ${HOME}/roles/

COPY playbook.yaml ${HOME}/playbook.yaml
COPY playbook_backup.yaml ${HOME}/playbook_backup.yaml
COPY playbook_restore.yaml ${HOME}/playbook_restore.yaml
COPY playbook_monitor.yaml ${HOME}/playbook_monitor.yaml