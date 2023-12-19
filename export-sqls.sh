#!/bin/bash

create_ini()
{
    (
        source .env
        cat << EOF > my.cnf
[client]
user=root
password=$MYSQL_PASSWORD
EOF
    )
}

copy_ini() { docker cp ./my.cnf mysqlito:/tmp; }

move_old_sqls() { mv mysql/for-import/*.sql mysql/for-import/old; }

create_sqls()
{
    today=$(date +"%d-%m-%Y-%H-%M-%S" --date="today")
    dbs=$(docker exec mysqlito /usr/bin/mysql --defaults-extra-file=/tmp/my.cnf -e 'SHOW DATABASES WHERE `database` NOT IN ("information_schema", "mysql", "sys", "performance_schema");' --skip-column-names)

    for db in $dbs; do
        docker exec mysqlito /usr/bin/mysqldump --defaults-extra-file=/tmp/my.cnf --databases $db > mysql/for-import/$db-$today.sql
    done
}

remove_ini()
{
    rm my.cnf
    docker exec mysqlito rm /tmp/my.cnf
}

create_ini
copy_ini
move_old_sqls
create_sqls
remove_ini
