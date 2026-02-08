#!/bin/bash

APP_NAME="nginx"

source ./common.sh

check_root

dnf module disable nginx -y &>>$LOGS_FILE
VALIDATE $? "Disabling nginx default version"

dnf module enable nginx:1.24 -y &>>$LOGS_FILE
VALIDATE $? "Enabling nginx 1.24 version"

dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installing ngnix"

systemctl enable nginx &>>$LOGS_FILE
systemctl start nginx 
VALIDATE $? "Enabling and starting nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "Downloading the code"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "Unzipping the content"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copied the nginx conf file"

systemctl restart nginx 
VALIDATE $? "Restarting nginx"

print_total_time