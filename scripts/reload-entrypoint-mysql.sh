#!/bin/bash

create_ini()
{
    (
        source ../.env
        cat << EOF > my.cnf
[client]
user=root
password=$MYSQL_PASSWORD
EOF
    )
}

copy_ini() { docker cp ./my.cnf mysqlito:/tmp; }

import_sqls()
{
    docker exec mysqlito sh -c 'cat $(ls /docker-entrypoint-initdb.d/*.sql | tac) | /usr/bin/mysql --defaults-extra-file=/tmp/my.cnf'
}

remove_ini()
{
    rm my.cnf
    docker exec mysqlito rm /tmp/my.cnf
}

create_ini
copy_ini
import_sqls
remove_ini
