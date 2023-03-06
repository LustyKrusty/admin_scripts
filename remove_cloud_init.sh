touch /etc/cloud/cloud-init.disabled &&
dpkg-reconfigure cloud-init &&
apt-get purge cloud-init &&
rm -rf /etc/cloud/ &&  rm -rf /var/lib/cloud/
echo "sleep 10"
sleep 10 &&
reboot now
