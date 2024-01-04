#!/bin/bash

. ./util/common.sh

RESULT=./log/60.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-62] FTP 서비스가 활성화 되어 있는 경우" >> $RESULT
echo " [양호] ftp 계정에 /bin/false 쉘이 부여되어 있는 경우" >> $RESULT
echo " [취약] ftp 계정에 /bin/false 쉘이 부여되어 있지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log
>$TMP2

cat /etc/passwd | grep -v -E "^#|^$" | grep ftp >$TMP2

if [ -s $TMP2 ] ; then
	shell=$(cat $TMP2 | awk -F: '{print $7}')
	if [ ! "$shell" == "/bin/false" ] || [ ! "$shell" == "/sbin/false" ] ; then
		WARN "ftp 계정의 쉘을 /bin/false 혹은 /sbin/false로 변경해주세요.">>$RESULT
		echo "현재 shell : $shell">>$RESULT
		retval="warning"
	else
		OK "올바르게 설정되어 있습니다.">>$RESULT
		retval="ok"
	fi
else
	OK "FTP 계정을 사용하지 않습니다.">>$RESULT
	retval="ok"
fi

echo "$retval"
