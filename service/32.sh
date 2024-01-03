#!/bin/bash

RESULT=./log/32.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-57] 홈디렉토리 소유자 및 권한 설정" >> $RESULT
echo " [양호] 홈 디렉터리 소유자가 해당 계정이고, 타 사용자 쓰기 권한이 제거된 경우" >> $RESULT
echo " [취약] 홈 디렉터리 소유자가 해당 계정이 아니고, 타 사용자 쓰기 권한이 부여된 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP1=./tmp/tmp1.log
TMP2=./tmp/tmp2.log

TRUEFALSE=1
 
cat /etc/passwd | grep -v -E '/sbin/nologin|/sbin/false|/bin/false' | awk -F: '$3 >= 500 && $3 <60000 {print $1,$6}' > $TMP1
 
while read USERNAME HOMEDIR
do
	LIST1=`ls -ald $HOMEDIR | awk '{print $3}'`
	LIST2=`ls -ald $HOMEDIR | awk '{print $1}'`
	find $HOMEDIR -type d -perm -600 -ls | grep -v drwx------ | grep $HOMEDIR$ > $TMP2
	if [ -s $TMP2 ] ; then
		echo "[WARN] $USERNAME 사용자의 홈 디렉터리 $HOMEDIR 권한을 확인 하십시오." >>$RESULT
		retval="warning"
		TRUEFALSE=0
	fi
	if [ $USERNAME != $LIST1 ] ; then
		echo "[WARN] $USERNAME 사용자의 홈 디렉터리 $HOMEDIR 소유자를 확인 하십시오.">>$RESULT
		retval="warning"
		TRUEFALSE=0
		ls -ld $HOMEDIR >> $RESULT
	fi
done < $TMP1
 
if [[ "$TRUEFALSE" -eq 1 ]] ; then
	echo "[OK] 사용자의 홈 디렉터리 소유자와 권한 설정이 양호합니다. ">>$RESULT
	retval="ok"
fi

echo "$retval"
