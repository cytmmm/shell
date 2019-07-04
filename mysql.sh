#!/bin/bash
#
#
#
#
#
#
HOSTNAME="127.0.0.1"                                           #数据库Server信息
PORT="3306"
USERNAME="root"
PASSWORD=""
dir=/data/mysql/sql
package_file=$(ls $dir)
MYSQL_CMD="mysql -uroot -p '$PASSWORD' "
for sql in $package_file;do
    OLD_IFS="$IFS"

    IFS="."
    sql_name=($sql)
    IFS=$OLD_IFS

    sql_n=${sql_name[0]}

    OLD_IFS="$IFS"
     #gzip  -d $sql
    IFS="_"
    file_array=($sql)
    IFS=$OLD_IFS

    dbname=${file_array[0]}
    # gzip  -d $sql.sql
    mysql -uroot -p $PASSWORD <创建的空数据库名> < ~/<解压缩后数据库名>.sql
    # create_db_sql="create database IF NOT EXISTS ${dbname}"
    #echo ${create_db_sql}  | ${MYSQL_CMD}
    if [[ $? -ne 0  ]]; then
        #statements
        echo  $dbname  创建失败
    fi
    # gzip -d  $sql
    done

