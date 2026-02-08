#!/bin/bash

source ./common.sh

APP_NAME="cart"

check_root
nodejs_installation
app_setup

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
VALIDATE $? "Creating systemctl services"

systemd_setup

print_total_time