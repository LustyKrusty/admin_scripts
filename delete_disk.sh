#Script for delete disks from os
#
#
#Before start delete /home/e775535/addrs_list and < /home/e775535/sd_list
#Put mpath list to /home/e775535/mpath_list
#After end - you can find id disks in /home/e775535/addrs_list
#
#
#
#!/usr/bin/bash
while read -r line; do
    mpath_name="$line"
    mpath_var=$(sudo multipath -ll $mpath_name)
    echo $mpath_var | grep -oP '\(\K[^\)]+' | grep -o '.\{3\}$' >> /home/e775535/addrs_list
    echo $mpath_var | grep -o '\bsd\w*' >> /home/e775535/sd_list
done < /home/e775535/mpath_list

while read -r line; do
   sd_name="$line"
   echo offline > /sys/block/$sd_name/device/state && echo 1  > /sys/block/$sd_name/device/delete
   sleep 1
done < /home/e775535/sd_list


