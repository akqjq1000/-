#!/bin/bash

RESULT=./log/27.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-16] /dev에 존재하지 않는 device 파일 점검" >> $RESULT
echo " [양호] dev에 대한 파일 점검 후 존재하지 않은 device 파일을 제거한 경우" >> $RESULT
echo " [취약] dev에 대한 파일 미점검 또는, 존재하지 않은 device 파일을 방치한 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP1=./tmp/tmp1.log
>$TMP1

find /dev -type f -exec ls -l {} \; > $TMP1
 
if [ -s $TMP1 ] ; then
	echo "[WARN] 파일이 존재합니다. ">>$RESULT
	cat $TMP1 >>$RESULT
	retval="warning"
else
	echo "[OK] 파일이 존재하지 않습니다. ">>$RESULT
	retval="ok"
fi

echo "$retval"
