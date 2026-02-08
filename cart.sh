#!/bin/bash

APP_NAME="cart"

source ./common.sh

check_root
nodejs_installation
app_setup
systemd_setup
print_total_time