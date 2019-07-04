#!/bin/bash
#
#
#
#
Dir=/mydata
ip="192.168.0."
passwd=1231231123
for (( i = 186; i < 206; i++ )); do
expect -c "
spawn scp ./ElemeAccountBrowser.php root@192.168.0.${i}:$Dir
expect {
\"*assword\" {set timeout 300; send \"$passwd\.\/\r\";}
\"yes/no\" {send \"yes\r\"; exp_continue;}
}
expect eof "
done
