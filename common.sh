#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER_ID=$(id -u)
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD


mkdir -p $LOGS_FOLDER 

START_TIME=(date+ %s)
echo "script started at $(date)" | tee -a $LOG_FILE

#check if the user has the root access or not


check_root()
{

    if [ $USER_ID -ne 0 ]
    then
        echo -e "${R}ERROR:You need Root access to run this script ${N}" | tee -a $LOG_FILE
        exit 90
    else
        echo -e "${G}You are running the script with the root access ${N}" | tee -a $LOG_FILE
    fi

}



#Validate function tells us if the command is successful or not

Validate(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is a${G} success ${N}" | tee -a $LOG_FILE
    else
        echo -e "$2 is a${R} Failure ${N}" | tee -a $LOG_FILE
        exit 90
    fi
}

nodejs_setup(){

    dnf module disable nodejs -y  &>> $LOG_FILE

    Validate $? "Disabling the default nodejs version" 

    dnf module enable nodejs:20 -y  &>> $LOG_FILE

    Validate $? "Enabling nodejs:20" 

    dnf install nodejs -y   &>> $LOG_FILE

    Validate $? "Installing nodejs"

    npm install  &>> $LOG_FILE

    Validate $? "Installing all the dependencies"

}

app_setup(){
    id roboshop_$SCRIPT_NAME  &>> $LOG_FILE

    if [ $? -ne 0 ]
    then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop_$SCRIPT_NAME  &>> $LOG_FILE
        Validate $? "Creating a system user"
    else
        echo -e "${Y}User has already been created ${N}" | tee -a $LOG_FILE
    fi

    mkdir -p /app
    Validate $? "Creating an app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>> $LOG_FILE

    Validate $? "Downloading the catalogue code"

    cd /app

    rm -rf *

    unzip /tmp/$app_name.zip  &>> $LOG_FILE

    Validate $? "Unzipping the catalogue code in the app directory"
}

maven_setup(){
    dnf install maven -y &>> $LOG_FILE

    Validate $? "Installing Maven"

    mvn clean package &>> $LOG_FILE

    Validate $? "Cleaning, compiling the java code and packaging into a jar file" 

    mv target/shipping-1.0.jar shipping.jar 

    Validate $? "moving the jar file to the app directory"

}

python_setup(){
    dnf install python3 gcc python3-devel -y &>> LOG_FILE

    Validate $? "Installing python"


    pip3 install -r requirements.txt &>> LOG_FILE


    Validate $? "Installing dependencies"

}

golang_setup(){
    dnf install golang -y &>> $LOG_FILE

    Validate $? "Installing golong" 

    id dispatch &>> $LOG_FILE

    go mod init dispatch &>> $LOG_FILE

    Validate $? "Initiating a new go module named dispatch"

    go get &>> $LOG_FILE

    Validate $? "Installing all the required dependencies"

    go build &>> $LOG_FILE

    Validate $? "Compiling the code"
}


system_setup(){
    cp /$SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service

    systemctl daemon-reload  &>> $LOG_FILE
    Validate $? "Reloaded the daemon"

    systemctl enable $app_name &>> $LOG_FILE
    Validate $? "Enabling the $app_name service"

    systemctl start $app_name   &>> $LOG_FILE

    Validate $? "Starting the $app_name service"

}
Print_time(){

    END_TIME=$(date+ %s)
    TIME_TAKE=$(($END_TIME-$START_TIME))
    
    echo -e "Script execution completed successfully, ${Y}time taken : ${G}$TIME_TAKEN seconds $N" | tee -a $LOG_FILE
}