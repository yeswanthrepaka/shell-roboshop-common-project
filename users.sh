#!/bin/bash

source ./common.sh

APP_NAME="user"

check_root
app_setup
nodejs_installation

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service
VALIDATE $? "Creating systemctl services"

systemd_setup

print_total_time