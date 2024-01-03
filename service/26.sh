#!/bin/bash

RESULT=./log/26.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-15] world writable 파일 점검" >> $RESULT
echo " [양호] 시스템 중요 파일에 world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우" >> $RESULT
echo " [취약] 시스템 중요 파일에 world writable 파일이 존재하나 해당 설정 이유를 확인하고 있지 않는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""
TMP1=./tmp/tmp1.log
TMP2=./tmp/tmp2.log
>$TMP2

find / -perm -2 -ls 2>/dev/null | grep -v -E '(/proc|lrwx|/tmp)' >$TMP2
 
cat $TMP2 | while read INUM1 NUM1 PERM1 OTHER
do
	echo $PERM1 | egrep -v '(^s|^d|^c|^b|t$)' > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
		echo $PERM1 $OTHER >> $TMP1
	fi
done

if [ -s $TMP1 ] ; then
	echo "[WARN] world writable 파일이 존재합니다." >>$RESULT
	cat $TMP1 >> $RESULT
	retval="warning"
else
	OK world writable 파일이 존재하지 않습니다.	
	retval="ok"
fi

echo "$retval"
