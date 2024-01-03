#!/bin/bash

RESULT=./log/33.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-58] 홈디렉토리로 지정한 디렉토리의 존재 관리" >> $RESULT
echo " [양호] 홈 디렉터리가 존재하지 않는 계정이 발견되지 않는 경우" >> $RESULT
echo " [취약] 홈 디렉터리가 존재하지 않는 계정이 발견된 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP1=./tmp/tmp1.log
FILE1=/etc/passwd
TRUEFALSE=1
 
cat /etc/passwd | grep -v -E '/sbin/nologin|/sbin/false|/bin/false' | awk -F: '$3 >= 500 && $3 <60000 {print $1,$6}' > $TMP1
 
while read USERNAME HOMEDIR
do
	if [ -z $HOMEDIR ] ; then
		echo "[WARN] $USERNAME 의 홈디렉터리가 존재하지 않습니다. " >>$RESULT
		retval="warning"
		TRUEFALSE=0
	fi
	if [ $HOMEDIR == '/' ] ; then
		echo "[WAR]N $USERNAME 의 홈디렉터리가 /로 설정되어 있습니다." >>$RESULT
		retval="warning"
		TRUEFALSEs=0
	fi
done < $TMP1
 
if [ $TRUEFALSE -eq 1 ] ; then
	echo "[OK] 사용자의 홈디렉터리 설정이 양호합니다. " >>$RESULT
	retval="ok"
fi

echo "$retval"
