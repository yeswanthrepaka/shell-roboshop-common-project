#!/bin/bash

source ./common.sh

check_root

mkdir -p $LOGS_FOLDER

dnf install maven -y &>>$LOGS_FILE
VALIDATE $? "Installing maven"

app_setup

cd /app
mvn clean package 
VALIDATE $? "Installing and building shipping"

mv target/shipping-1.0.jar shipping.jar &>>$LOGS_FILE
VALIDATE $? "Cleaning package and renaming the jar file as shipping"

cp $SCRIPT_NAME/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "Copying shipping service file"

systemd_setup

dnf install mysql -y  &>>$LOGS_FILE
VALIDATE $? "Installing MySQL"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'
if [ $? -ne 0 ]; then

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOGS_FILE
    VALIDATE $? "Loaded data into MySQL"
else
    echo -e "data is already loaded ... $Y SKIPPING $N"
fi

auto_restart
print_total_time