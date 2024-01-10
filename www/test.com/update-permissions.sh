#!/bin/bash
[[ -z "${1}" ]] && user='root' || user=${1}
group=www-data
folder_name=public_html
chown -R $user $folder_name
chgrp -R $group $folder_name
find $folder_name -type d -not -path '*/vendor/*' -exec chmod 775 {} \;
find $folder_name -type f -not -path '*/vendor/*' -exec chmod 664 {} \;
chmod -R g+s $folder_name
