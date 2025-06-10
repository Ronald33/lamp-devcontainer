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

create_sqls()
{
    today=$(date +"%d-%m-%Y-%H-%M-%S" --date="today")
    dbs=$(docker exec mysqlito mysql --defaults-extra-file=/tmp/my.cnf -e 'SHOW DATABASES WHERE `database` NOT IN ("information_schema", "mysql", "sys", "performance_schema");' --skip-column-names)

    for db in $dbs; do
	docker exec mysqlito mysqldump --defaults-extra-file=/tmp/my.cnf --databases --routines --no-create-info --no-data --skip-triggers $db | sed -E 's/DEFINER[=`"a-zA-Z0-9@._%-]*//' > ../generateds/routines/$db-$today-routines.sql
    done
}

remove_ini()
{
    rm my.cnf
    docker exec mysqlito rm /tmp/my.cnf
}

create_ini
copy_ini
create_sqls
remove_ini
