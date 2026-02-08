#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
SCRIPT_DIR=$PWD

check_root(){
    if [ $USERID -ne 0 ]; then
        echo -e " $R Please run the script with root user $N " | tee -a $LOGS_FILE
        exit 1
    fi
}

mkdir -p $LOGS_FOLDER

VALIDATE (){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

enable_start(){
    systemctl enable $APP_NAME &>>$LOGS_FILE
    VALIDATE $? "Enabling $APP_NAME"

    systemctl start $APP_NAME 
    VALIDATE $? "Starting $APP_NAME"
}

auto_restart(){
    systemctl restart $APP_NAME
    VALIDATE $? "Restarting $APP_NAME"
}

