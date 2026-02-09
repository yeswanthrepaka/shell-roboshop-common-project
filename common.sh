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
MONGODB_HOST="mongodb.repaka.online"
MYSQL_HOST="mysql.repaka.online"

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

nodejs_installation(){
    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Disabling nodejs default version"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "Enabling nodejs version 20"

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Installing nodejs"

    npm install &>>$LOGS_FILE
    VALIDATE $? "Installing dependencies"
}

app_setup(){
    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        VALIDATE $? "Adding roboshop user"
    else
        echo -e "$Y Roboshop user already exists... SKIPPING $N"
    fi

    mkdir -p /app
    VALIDATE $? "Creating app directory"

    curl -o /tmp/$APP_NAME.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
    VALIDATE $? "Dowloading code"

    cd /app
    VALIDATE $? "Moving to app directiory"

    rm -rf /app/*
    VALIDATE $? "Removing older files"

    unzip /tmp/$APP_NAME.zip
    VALIDATE $? "Unzipping the code"
}

java_setup(){
    dnf install maven -y &>>$LOGS_FILE
    VALIDATE $? "Installing maven"

    cd /app
    mvn clean package 
    VALIDATE $? "Installing and building shipping"

    mv target/shipping-1.0.jar shipping.jar &>>$LOGS_FILE
    VALIDATE $? "Cleaning package and renaming the jar file as shipping"

}

systemd_setup(){
    cp $SCRIPT_DIR/$APP_NAME.service /etc/systemd/system/$APP_NAME.service
    VALIDATE $? "Creating systemctl services"

    systemctl daemon-reload
    VALIDATE $? "Daemon reload"

    systemctl enable $APP_NAME &>>$LOGS_FILE
    VALIDATE $? "Enabling $APP_NAME"

    systemctl start $APP_NAME
    VALIDATE $? "Starting $APP_NAME"
}

auto_restart(){
    systemctl restart $APP_NAME
    VALIDATE $? "Restarting $APP_NAME"
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$B Script completion time: $TOTAL_TIME SECONDS $N"
}