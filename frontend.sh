#!/bin/bash

source ./common.sh
check_root

dnf module disable nginx -y &>> $LOG_FILE
Validate $? "Disabling nginx default version"

dnf module enable nginx:1.24 -y &>> $LOG_FILE
Validate $? "Enabling nginx version 1.24"

dnf install nginx -y &>> $LOG_FILE
Validate $? "Installing nginx"

systemctl enable nginx &>> $LOG_FILE

Validate $? "Enabling nginx"

systemctl start nginx &>> $LOG_FILE

Validate $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
Validate $? "Removing the existing content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOG_FILE

Validate $? "Downloading the frontend code"

cd /usr/share/nginx/html 

unzip /tmp/frontend.zip &>> $LOG_FILE

Validate $? "Unzipping the frontend code"

rm -rf /etc/nginx/nginx.conf &>> $LOG_FILE
Validate $? "Removing the existing nginx configuration file"

cp /$SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf 

Validate $? "Copying the nginx configuration file to its default location"

systemctl restart nginx &>> $LOG_FILE

Validate $? "Restarting nginx"






