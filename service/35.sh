#!/bin/bash

RESULT=./log/35.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-19] Finger 서비스 비활성화" >> $RESULT
echo " [양호] Finger 서비스가 비활성화 되어 있는 경우" >> $RESULT
echo " [취약] Finger 서비스가 활성화 되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

which finger 2> /dev/null >>$RESULT

if [ $? -eq 0 ] ; then
	echo "[INFO] Finger 서비스가 설치되어 있습니다." >>$RESULT
	retval="warning"
else
	echo "[OK] Finger 서비스가 설치 되어 있지 않습니다." >>$RESULT
	retval="ok"
fi

echo "$retval"
