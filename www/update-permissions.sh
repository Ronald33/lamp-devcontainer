#!/bin/bash
[[ -z "${USER}" ]] && USER='root'
chmod -R 775 .
chown -R $USER .
chgrp -R www-data .
chmod -R g+s .
find . -type f -exec chmod 660 {} \;
chmod u+x update-permissions.sh
