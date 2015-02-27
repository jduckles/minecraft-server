#!/bin/bash
S3_BUCKET=s3://jduck-minecraft-backup
WORLD=duckland-creative

# Uses the tugboat app for DigitalOcean to bring up the VM.
if [ -n $(tugboat droplets |grep minecraft) ]; then
  tugboat create minecraft -s 64 -i 10581649 -r 1 -k 14937
  tugboat info minecraft |grep IP: | sed 's/IP:               //g'
else;
  echo "looks like it is already running"
fi

# Wait for VM to exit new status
echo "Bringing up the server, this could take a few:"
while [[ -n $(tugboat info minecraft | grep "Status" | grep "new" ) ]]; do
  echo -n .
  sleep 5
done

# Grab the VM's IP
VM_IP=$(tugboat info minecraft |grep IP: | sed 's/IP:               //g')

## Pull s3backup
scp ~/.s3cfg root@${VM_IP}:.
ssh ${VM_IP} apt-get install -y s3cmd

# Sync server data
ssh root@${VM_IP} mkdir -m 777 -p /opt/msm/servers
ssh root@${VM_IP} s3cmd sync ${S3_BUCKET} /opt/msm/servers

VOLUMES="-v /opt/msm/server:/opt/msm/servers"
DOCKER_OPTS="--net="host" -d jduckles/minecraft"
COMMAND="exec msm ${WORLD} start"
DOCKER_RUN="docker run ${VOLUMES} ${DOCKER_OPTS} ${COMMAND}"
