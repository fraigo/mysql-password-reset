#!/bin/bash
#
# Mysql Password reset script
# ----------------------------------------------------------------
# Author    : Francisco Igor <franciscoigor@gmail.com>
# References: https://help.ubuntu.com/community/MysqlPasswordReset 
# 

export NEWPASSWORD = 123456

# Stop the mysql demon process using this command :
sudo /etc/init.d/mysql stop

# Start the mysqld demon process using the --skip-grant-tables option with this command 
sudo /usr/sbin/mysqld --skip-grant-tables --skip-networking &

# Because you are not checking user privs at this point, it's safest to disable networking. 
# In Dapper, /usr/bin/mysqld... did not work. However, mysqld --skip-grant-tables did.

# start the mysql client process using this command 
# Execute this command to be able to change any password
mysql -u root -e "SHOW PRIVILEGES"

# Then reset/update your password 
#   SET PASSWORD FOR root@'localhost' = PASSWORD('password');
# If you have a mysql root account that can connect from everywhere, you should also do:
#   UPDATE mysql.user SET Password=PASSWORD('newpwd') WHERE User='root';

# Alternate Method:
mysql -u root -e "USE mysql; UPDATE user SET Password = PASSWORD('$NEWPASSWORD') WHERE Host = 'localhost' AND User = 'root';"

# And if you have a root account that can access from everywhere:
mysql -u root -e "USE mysql; UPDATE user SET Password = PASSWORD('$NEWPASSWORD') WHERE Host = '%' AND User = 'root';"

# For either method, once have received a message indicating a successful query (one or more rows affected), flush privileges:
mysql -u root -e "SHOW PRIVILEGES"


# Then stop the mysqld process and relaunch it with the classical way:

sudo /etc/init.d/mysql stop
sudo /etc/init.d/mysql start
