#!/bin/bash

source ./common.sh

app_name=rabbitmq

check_root

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo

Validate $? "Adding the rabbitmq server"

dnf install rabbitmq-server -y &>> $LOG_FILE

Validate $? "Installing rabbitmq server"

systemctl enable rabbitmq-server &>> $LOG_FILE

Validate $? "Enabling the rabbitmq sever"

systemctl start rabbitmq-server &>> $LOG_FILE

Validate $? "Starting rabbitmq"


echo -e "${Y}Enter the rabbitmq password to setup${N}" | tee -a $LOG_FILE
read -s RABBITMQ_PASSWD
rabbitmqctl add_user roboshop $RABBITMQ_PASSWD &>> $LOG_FILE

Validate $? "Creating a user in rabbitmq"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE

Validate $? "Setting permissions to the user"

Print_time