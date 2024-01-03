#!/bin/bash

. ./util/common.sh

RESULT=./log/44.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-28] NIS, NIS+ 점검" >> $RESULT
echo " [양호] NIS 서비스가 비활성화 되어 있거나, 필요 시 NIS+를 사용하는 경우" >> $RESULT
echo " [취약] NIS 서비스가 활성화 되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP=./tmp/tmp1.log
 
ps -ef | egrep "ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated" | grep -v grep | awk '{print $2,$8}'> $TMP
 
if [ -s $TMP ] ; then
	cat $TMP | while read PID PROCESS
	do
		WARN $PID / $PROCESS 가 구동중 입니다. 
	done
else
	OK NIS 서비스가 비활성화 되어있습니다.
fi

echo "$retval"
