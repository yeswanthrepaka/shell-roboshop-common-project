#!/bin/bash

source ./common.sh

APP_NAME="user"

check_root
nodejs_installation
app_setup

cp $SCRIPT_NAME/user.service /etc/systemd/system/user.service
VALIDATE $? "Creating systemctl services"

systemd_setup

print_total_time