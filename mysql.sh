#!/bin/bash

source ./common.sh

check_root

mkdir -p $LOGS_FOLDER

dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "Installing mysql server"

systemctl enable mysqld 
systemctl start mysqld  
VALIDATE $? "Enabling and starting mysqld"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setup root passowrd"