#!/bin/bash

. ./util/common.sh

RESULT=./log/64.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-66] SNMP 서비스 구동 점검" >> $RESULT
echo " [양호] SNMP 서비스를 사용하지 않는 경우" >> $RESULT
echo " [취약] SNMP 서비스를 사용하는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

ps -ef | grep -v grep | grep snmpd 2> /dev/null > /dev/null

if [ $? -eq 0 ] ; then
	WARN "snmp 서비스가 구동중입니다.">>$RESULT
	retval="warning"
else
	OK "snmp 서비스가 구동중이지 않습니다.">>$RESULT
	retval="ok"
fi

echo "$retval"
