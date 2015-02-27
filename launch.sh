#!/bin/bash
S3_BUCKET=s3://jduck-minecraft-backup
WORLD=duckland-creative
DOCKER=jduckles/minecraft
VM_NAME="minecraft"

# Uses the tugboat app for DigitalOcean to bring up the VM.
if [ -z "$(tugboat droplets |grep ${VM_NAME})" ] ; then
  tugboat create ${VM_NAME} -s 64 -i 10581649 -r 1 -k 14937
  tugboat info minecraft |grep IP: | sed 's/IP:               //g'
  # Wait for VM to exit 'new' status before proceeding
  echo "Bringing up the server, this could take a few:"
  sleep 5
  while [ -n "$(tugboat info ${VM_NAME} | grep "Status" | grep "new" )" ] ; do
    echo -n .
    sleep 5
  done
else
  echo "looks like it is already running"
fi





# Grab the VMs IP
VM_IP=$(tugboat info ${VM_NAME} |grep IP: | sed 's/IP:               //g')

sed -i .old "/${VM_IP}/d" ~/.ssh/known_hosts

SSH_COMMAND="ssh root@${VM_IP}"
## Pull s3backup
${SSH_COMMAND} ~/.s3cfg root@${VM_IP}:.
${SSH_COMMAND} apt-get install -y s3cmd ufw

# Sync server data
${SSH_COMMAND} mkdir -m 777 -p /opt/msm/servers
# Sync worlds from last time the server was up
${SSH_COMMAND} s3cmd sync ${S3_BUCKET} /opt/msm/servers
# bring up firewall and poke a hole
${SSH_COMMAND} ufw enable && ufw allow 25565/tcp

# Mount the games volumes with server backups
VOLUMES="-v /opt/msm/servers:/opt/msm/servers"
DOCKER_OPTS="--net="host" -d ${DOCKER}"
COMMAND="exec msm ${WORLD} start"
DOCKER_RUN="docker run ${VOLUMES} ${DOCKER_OPTS} ${COMMAND}"
${SSH_COMMAND} ${DOCKER_RUN}
