#!/bin/bash
path="${1:-$MY_WORKDIR}"
user="${2:-$MY_USER_NAME}"
group="${3:-$MY_GROUP_NAME}"

if [[ -z "$path" || -z "$user" || -z "$group" ]]; then
  echo "Faltan parámetros requeridos: path, user o group"
  exit 1
fi

chown -R "$user" "$path"
chgrp -R "$group" "$path"
find "$path" -type d -exec chmod 770 {} \;
find "$path" -type f -not -perm /u=x,g=x,o=x -exec chmod 660 {} \;
chmod -R g+s "$path"

pgrep -x "apache2" > /dev/null || apache2-foreground
