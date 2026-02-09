#!/bin/bash

source ./common.sh
APP_NAME=payment

check_root

mkdir -p $LOGS_FOLDER

app_setup
python_setup
systemd_setup
print_total_time