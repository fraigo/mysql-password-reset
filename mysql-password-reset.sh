#!/bin/bash
#
# Mysql Password reset script
# ----------------------------------------------------------------
# Author    : Francisco Igor <franciscoigor@gmail.com>
# References: https://help.ubuntu.com/community/MysqlPasswordReset 
# 

message () {
  echo -e "\033[0;32m$1\033[0m"
  sleep 1
}

export NEWPASSWORD=123456

message "Stop the mysql daemon process using this command"
sudo /etc/init.d/mysql stop

message "Start the mysqld daemon process"
sudo /usr/sbin/mysqld --skip-grant-tables --skip-networking &

message "Flushing privileges"
mysql -u root -e "FLUSH PRIVILEGES"

message "Reset/update your password" 
mysql -u root -e "SET PASSWORD FOR root@'localhost' = PASSWORD('$NEWPASSWORD');"

message "Reset/update your password - local access" 
mysql -u root -e "UPDATE mysql.user SET Password = PASSWORD('$NEWPASSWORD') WHERE Host = 'localhost' AND User = 'root';"

message "Reset/update your password - remote access" 
mysql -u root -e "UPDATE mysql.user SET Password = PASSWORD('$NEWPASSWORD') WHERE Host = '%' AND User = 'root';"

message "Flushing privileges" 
mysql -u root -e "FLUSH PRIVILEGES"

message "Stop the mysqld process"
sudo /etc/init.d/mysql stop

message "Restart mysql daemon. Please wait..."
sudo /etc/init.d/mysql start
