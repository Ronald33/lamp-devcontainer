#!/bin/bash
[[ -z "${1}" ]] && user='root' || user=${1}
group=www-data
folder_name=public_html
chown -R $user $folder_name
chgrp -R $group $folder_name
find $folder_name -type d -exec chmod 770 {} \;
find $folder_name -type f -not -perm /u=x,g=x,o=x -exec chmod 660 {} \;
chmod -R g+s $folder_name
