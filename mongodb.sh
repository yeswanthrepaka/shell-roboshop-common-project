#!/bin/bash

source ./common.sh

APP_NAME="Mmongodb"

check_root

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing mongodb"

systemctl enable mongod &>>$LOGS_FILE
systemctl start mongod
VALIDATE $? "Enabling and starting $APP_NAME"

sed -i s/127.0.0.1/0.0.0.0/g /etc/mongod.conf 
VALIDATE $? "Allowing remote connection"

auto_restart