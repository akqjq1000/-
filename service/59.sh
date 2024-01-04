#!/bin/bash

. ./util/common.sh

RESULT=./log/59.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-61] ftp 서비스 확인" >> $RESULT
echo " [양호] FTP 서비스가 비활성화 되어 있는 경우" >> $RESULT
echo " [취약] FTP 서비스가 활성화 되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

ps -ef | grep -v grep | grep -E "proftpd|vsftpd" 2> /dev/null >>$RESULT

if [ $? -eq 0 ] ; then
	WARN "FTP 서비스가 구동중입니다.">>$RESULT
	retval="warning"
else
	OK "FTP 서비스가 구동중이지 않습니다.">>$RESULT
	retval="ok"
fi

echo "$retval"
