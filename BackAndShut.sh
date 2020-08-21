#!/bin/bash -xv
# daily backup and shutdown of both the backup and the actual servers
echo "===== Backup script ====="
echo "--- Preparing ---"
# 1. mount NFS
echo "Mounting NFS partition..."
mount 192.168.1.13:/mnt/data /mnt/nfs
# 2. Put Nextcloud in maintenance mode
echo "Putting Nextcloud in maintenance mode..."
sudo -u apache php /var/lib/nextcloud/occ maintenance:mode --on
echo "Done preparing !"
echo "--- Backing up ---"
# 3. backup nextcloud data
echo "Backing nextcloud data and configuration..."
mkdir /mnt/nfs/backups/nextcloud/nextcloud-dirbkp_`date +"%Y-%m"`/
rsync -Aavxm --exclude='files_*' /var/lib/nextcloud/data /mnt/nfs/backups/nextcloud/nextcloud-dirbkp_`date +"%Y-%m"`/data/
rsync -Aavx /var/lib/nextcloud/config /mnt/nfs/backups/nextcloud/nextcloud-dirbkp_`date +"%Y-%m"`/config/
# 4. backup Apache
echo "Backing Apache directory..."
rsync -Aavx /etc/httpd /mnt/nfs/backups/apache/httpd-dirbkp_`date +"%Y-%m"`/
# 5. backup McMyAdmin
echo "Backing up McMyAdmin..."
mkdir /mnt/nfs/backups/McMyAdmin/McMyAdmin-dirbkp_`date +"%Y-%m"`/
rsync -Aavx /home/snyssen/McMyAdmin/Backups /mnt/nfs/backups/McMyAdmin/McMyAdmin-dirbkp_`date +"%Y-%m"`/Backups/
# 6. backup Terraria
echo "Backing up Terraria Worlds"
mkdir /mnt/nfs/backups/Terraria/Worlds_`date +"%Y-%m%d"`/
rsync -Aavx /home/snyssen/.local/share/Terraria/Worlds /mnt/nfs/backups/Terraria/Worlds_`date +"%Y-%m%d"`/
# 7. backup databases
echo "Backing up all databases..."
mysqldump --defaults-file=/home/snyssen/.mysql.cnf --all_databases > /mnt/nfs/backups/mysqldump/dump_`date +"%Y-%m-%d"`.sql
echo "Done backing up !"
echo "-- Cleaning up ---"
# 8. remove maintenance mode of Nextcloud
echo "Removing maintenance mode from Nextcloud..."
sudo -u apache php /var/lib/nextcloud/occ maintenance:mode --off
# 9. Unmount NFS
echo "Unmounting NFS partition..."
umount /mnt/nfs
# 10. Shutdown of backup server
echo "Shutting down backup server..."
ssh root@192.168.1.13 poweroff
# 11. Shutdown of main server
echo "All done !"
wall "===== SHUTTING DOWN MAIN SERVER FOR THE NIGHT IN 15 MINUTES ====="
wall "To prevent shutdown you may use sudo shutdown -c"
shutdown -h +15
