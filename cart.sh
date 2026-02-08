#!/bin/bash

source ./common.sh

APP_NAME="cart"

check_root
app_setup
nodejs_installation

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
VALIDATE $? "Creating systemctl services"

systemd_setup

print_total_time