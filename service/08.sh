#!/bin/bash

RESULT=./log/08.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-47] 패스워드 최대 사용기간 설정" >> $RESULT
echo " [양호] 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있는 경우" >> $RESULT
echo " [취약] 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있지 않는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

INFO_FILE=$(grep -v -E '^#|^$' /etc/login.defs | grep PASS_MAX_DAYS)
CHECK_FILE=$(grep -v -E '^#|^$' /etc/login.defs | grep PASS_MAX_DAYS | awk '{print $2}')

if [ -n "$INFO_FILE" ] ; then
	if [ $CHECK_FILE -le 90 ] ; then
		echo "[OK] 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있습니다." >>$RESULT
		retval="ok"
	else
		echo "[WARN] 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있지 않습니다.">>$RESULT
		retval="warning"
		echo "===================================================" >> $RESULT
		echo "1. /etc/login.defs 파일의 내용입니다." >> $RESULT
		echo "" >> $RESULT
		echo $INFO_FILE >> $RESULT
		echo "===================================================" >> $RESULT
	fi
fi

echo "$retval"
