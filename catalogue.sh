#!/bin/bash

source ./common.sh

APP_NAME="catalogue"

check_root
nodejs_installation
app_setup

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Created systemctl service"

systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y &>>$LOGS_FILE
VALIDATE $? "Installing mongodb"

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

    if [ $INDEX -le 0 ]; then
        mongosh --host $MONGODB_HOST </app/db/master-data.js
        VALIDATE $? "Loading products"
    else
        echo -e "$Y Products already loaded... SKIPPING $N"
    fi

auto_restart