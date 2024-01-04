#!/bin/bash

. ./util/common.sh

RESULT=./log/50.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-34] DNS Zone Transfer 설정" >> $RESULT
echo " [양호] DNS 서비스 미사용 또는, Zone Transfer를 허가된 사용자에게만 허용한 경우" >> $RESULT
echo " [취약] DNS 서비스를 사용하며 Zone Transfer를 모든 사용자에게 허용한 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

ps -ef | grep -v grep | grep named 2> /dev/null > /dev/null

if [ ! $? -eq 0 ] ; then
	OK "DNS 서비스를 사용하지 않습니다." >>$RESULT
	retval="ok"
else
	WARN "DNS 서비스를 사용 중입니다.">>$RESULT
	INFO "학내 DNS 서버는 210.115.32.105, 210.115.33.105가 유일합니다.">>$RESULT
	retval="warning"
fi

echo "$retval"
