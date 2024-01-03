#!/bin/bash

. ./util/common.sh

RESULT=./log/42.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-26] automountd 제거" >> $RESULT
echo " [양호] automountd 서비스가 비활성화 되어 있는 경우" >> $RESULT
echo " [취약] automountd 서비스가 활성화 되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

ps -ef | grep -v grep | grep "automount" >> $RESULT

if [ $? -eq 0 ] ; then
	WARN "automountd 서비스를 종료해주세요."
	retval="warning"
else
	OK "automountd 서비스가 비활성화 되어있습니다."
	retval="ok"
fi

echo "$retval"
