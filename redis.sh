#!/bin/bash

source ./common.sh

app_name=redis

check_root

dnf module disable redis -y &>> $LOG_FILE

Validate $? "Disabling the default version for redis"

dnf module enable redis:7 -y &>> $LOG_FILE

Validate $? "Enabliing the redis version 7"

dnf install redis -y &>> $LOG_FILE

Validate $? "Installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf

Validate $? "Changing the redis configuration file"


systemctl enable redis &>> $LOG_FILE

Validate $? "Enabling redis"

systemctl start redis &>> $LOG_FILE
Validate $? "Starting redis"

Print_time
