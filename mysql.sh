#!/bin/bash

source ./common.sh

app_name=mysql
check_root

dnf install mysql-server -y  &>> $LOG_FILE

Validate $? "Installing mysql server"

 
systemctl enable mysqld &>> $LOG_FILE

Validate $? "Enabling mysql"

systemctl start mysqld &>> $LOG_FILE

Validate $? "Starting mysql"

echo "Please enter mysql root password to setup"
read -s MYSQL_ROOT_PASSWORD

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD &>> $LOG_FILE

Validate $? "Setting Mysql root password"


Print_time