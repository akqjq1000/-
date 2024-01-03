#!/bin/bash

RESULT=./log/07.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-46] 패스워드 최소 길이 설정" >> $RESULT
echo " [양호] 패스워드 최소 길이가 8자 이상으로 설정되어 있는 경우" >> $RESULT
echo " [취약] 패스워드 최소 길이가 8자 미만으로 설정되어 있지 않은  경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

INFO_FILE=$(grep -v -E '^#|^$' /etc/login.defs | grep PASS_MIN_LEN)
CHECK_FILE=$(grep -v -E '^#|^$' /etc/login.defs | grep PASS_MIN_LEN | awk '{print $2}')

if [ -n "$INFO_FILE" ] ; then
	if [ $CHECK_FILE -lt 8 ] ; then
		echo '[WARN] 패스워드 최소 길이가 8자 미만으로 설정되어 있는 경우 입니다.'>>$RESULT
		retval="warning"
	else
		echo '[OK] 패스워드 최소 길이가 8자 이상으로 설정되어 있습니다.'>>$RESULT
		retval="ok"
	fi 
else
	echo '[WARN] 패스워드 최소 길이가 8자 미만으로 설정되어 있는 경우 입니다.'>>$RESULT
	retval="warning"
fi

echo "$retval"
