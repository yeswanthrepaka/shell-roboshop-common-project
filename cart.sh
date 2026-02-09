#!/bin/bash

APP_NAME="cart"

source ./common.sh

check_root
app_setup
nodejs_installation
systemd_setup
print_total_time