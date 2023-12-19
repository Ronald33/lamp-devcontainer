#!/bin/bash
[[ -z "${1}" ]] && USER='root' || USER=${1}
folder_name=public_html
chown -R $USER $folder_name
chgrp -R www-data $folder_name
find $folder_name -type d -not -path '*/vendor/*' -exec chmod 775 {} \;
find $folder_name -type f -not -path '*/vendor/*' -exec chmod 664 {} \;
chmod -R g+s $folder_name
