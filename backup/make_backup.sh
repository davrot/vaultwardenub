#!/bin/bash
rsync -avz --delete -e "ssh -i /root/backup/backup" /root paserver@backup.zfn.uni-bremen.de:/home/paserver/backup_root/root
docker exec -it backup /bin/sh -c 'cd /data/ ; rsync -avz --delete -e "ssh -o StrictHostKeyChecking=accept-new -i /data/backup" /data/backup_docker paserver@backup.zfn.uni-bremen.de:/home/paserver/backup_docker/'

echo "Backup completed"

