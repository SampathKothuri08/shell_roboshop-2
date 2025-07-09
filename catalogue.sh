#!/bin/bash

source ./common.sh

app_name=catalogue

check_root

app_setup

nodejs_setup

system_setup

cp /$SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y  &>> $LOG_FILE

Validate $? "Installing mongosh, the mongodb client"

STATUS=$(mongosh --host mongodb.devopseng.shop --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $STATUS -lt 0 ]
then 
    mongosh --host mongodb.devopseng.shop </app/db/master-data.js  &>> $LOG_FILE
    Validate $? "Loading the data into mongodb server"
else
    echo -e "${Y}Data is already loaded, skip it!${N}" | tee -a $LOG_FILE
fi

Print_time


