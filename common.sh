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
START_TIME=$(date +%s)

check_root(){
    if [ $USERID -ne 0 ]; then
        echo -e " $R Please run the script with root user $N " | tee -a $LOGS_FILE
        exit 1
    fi
}

echo "Script started executing at: $(date "+%Y-%m-%d %H:%M:%S")"

mkdir -p $LOGS_FOLDER

VALIDATE (){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

auto_restart(){
    systemctl restart $APP_NAME
    VALIDATE $? "Restarting $APP_NAME"
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($START_TIME - $END_TIME))"
    echo -E "$B Script completion time: $TOTAL_TIME SECONDS $N"
}