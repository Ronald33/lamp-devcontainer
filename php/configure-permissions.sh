#!/bin/bash

show_help() {
  cat <<EOF
Uso: configure-permissions <path> <user> <group>

Aplica permisos recursivos a un directorio para un usuario y grupo específicos.

Parámetros:
  <path>     Ruta del directorio objetivo (debe existir).
  <user>     Nombre del usuario propietario.
  <group>    Nombre del grupo propietario.

Ejemplo:
  configure-permissions /var/www/html www-data www-data

Opciones:
  -h, --help     Muestra esta ayuda y sale.
EOF
}

# Mostrar ayuda si se pasa -h o --help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
  exit 0
fi

# Extraer parámetros
path="$1"
user="$2"
group="$3"

# Validar argumentos
if [[ -z "$path" || -z "$user" || -z "$group" ]]; then
  echo "Error: Faltan parámetros."
  echo "Usa 'configure-permissions --help' para ver cómo usar el comando."
  exit 1
fi

echo "Asignando permisos en $path para usuario $user y grupo $group..."

chown -R "$user" "$path"
chgrp -R "$group" "$path"
find "$path" -type d -exec chmod 770 {} \;
find "$path" -type f -not -perm /u=x,g=x,o=x -exec chmod 660 {} \;
chmod -R g+s "$path"

echo "Permisos aplicados correctamente."
