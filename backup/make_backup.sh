#!/bin/bash
rsync -avz --delete -e "ssh -i /root/backup/backup" /root paserver@backup.zfn.uni-bremen.de:/home/paserver/backup_root/root

# Set variables
REMOTE_USER="paserver"
REMOTE_HOST="backup.zfn.uni-bremen.de"
REMOTE_DIR="/home/paserver/backup_docker"
SSH_KEY="/root/backup/backup"

# Get list of all Docker volumes
volumes=$(docker volume ls --format "{{.Name}}")

# Backup each volume
for volume in $volumes
do
    echo "Backing up volume: $volume"
    
    # Create a new container from busybox image, mount the volume and tar it up,
    # then pipe it directly to the remote server via SSH
    docker run --rm -v $volume:/volume busybox tar cf - /volume | \
    ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST "cat > $REMOTE_DIR/$volume.tar"

    echo "Finished backing up $volume"
done

echo "Backup completed"
