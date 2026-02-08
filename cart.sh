#!/bin/bash

source ./common.sh

APP_NAME="cart"

check_root
nodejs_installation
app_setup
systemd_setup
print_total_time