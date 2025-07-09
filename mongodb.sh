#!/bin/bash


source ./common.sh 
app_name=mongodb

check_root



cp mongo.repo /etc/yum.repos.d/mongo.repo

Validate $? "Copying the mongo repo"

dnf install mongodb-org -y &>> $LOG_FILE

Validate $? "installing mongodb"

systemctl enable mongod &>> $LOG_FILE

Validate $? "Enabing mongodb"

systemctl start mongod &>> $LOG_FILE

Validate $? "Starting mongodb"

sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

Validate $? "Giving access to the remote connections"

systemctl restart mongod &>> $LOG_FILE

Validate $? "Restarting Mongodb"

Print_time







