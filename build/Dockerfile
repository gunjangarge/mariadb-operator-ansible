FROM quay.io/operator-framework/ansible-operator:latest

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
 && chmod -R ug+rwx ${HOME}/.ansible

RUN python3 -m pip install PyMySQL --user 

COPY watches.yaml ${HOME}/watches.yaml

COPY roles/ ${HOME}/roles/

COPY playbooks/playbook.yaml ${HOME}/playbook.yaml
COPY playbooks/playbook_backup.yaml ${HOME}/playbook_backup.yaml
COPY playbooks/playbook_restore.yaml ${HOME}/playbook_restore.yaml
COPY playbooks/playbook_monitor.yaml ${HOME}/playbook_monitor.yaml