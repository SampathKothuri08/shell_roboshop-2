#!/bin/bash

source ./common.sh

app_name=shipping

check_root

app_setup

maven_setup

system_setup


dnf install mysql -y &>> $LOG_FILE

Validate $? "Installing mysql"

echo -e "${Y}Enter Mysql root password ${N}" 

read -s MYSQL_ROOT_PASSWORD

mysql -h mysql.devopseng.shop -u root -p$MYSQL_ROOT_PASSWORD -e 'use cities' &>>$LOG_FILE

if [ $? -eq 0 ]
then
    echo -e "${y}Data is already loaded into the mysql ${N}"
else
    mysql -h mysql.devopseng.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql &>> $LOG_FILE

    mysql -h mysql.devopseng.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql &>> $LOG_FILE

    mysql -h mysql.devopseng.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql &>> $LOG_FILE

    Validate $? "loading the data into mysql"
fi


systemctl restart shipping &>> $LOG_FILE

Validate $? "Restarting shipping"

Print_time

