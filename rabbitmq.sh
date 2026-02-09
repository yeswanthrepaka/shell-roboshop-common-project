#!/bin/bash

source ./common.sh

SCRIPT_DIR=$PWD
APP_NAME=rabbitmq

check_root

mkdir -p $LOGS_FOLDER


cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Copying repo to yum repos"

dnf install rabbitmq-server -y &>>$LOGS_FILE
VALIDATE $? "Installing rabbitmq server"

systemctl enable rabbitmq-server &>>$LOGS_FILE
systemctl start rabbitmq-server
VALIDATE $? "Enabling and starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGS_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILE
VALIDATE $? "Created user and permissions added for that user"