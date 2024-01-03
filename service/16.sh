#!/bin/bash

RESULT=./log/16.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-05] root홈, 패스 디렉터리 권한 및 패스 설정" >> $RESULT
echo " [양호] PATH 환경변수에 “.” 이 맨 앞이나 중간에 포함되지 않은 경우" >> $RESULT
echo " [취약] PATH 환경변수에 “.” 이 맨 앞이나 중간에 포함되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

ROOTPATH=$(su - root -c 'echo $PATH')
CHECKPATH=$(echo $ROOTPATH | grep -E '^:|:$|::|^.:|:.:|:.$')
if [ -z $CHECKPATH ] ; then
	echo "[OK] PATH 환경변수에 "." 이 맨 앞이나 중간에 포함되지 않았습니다." >>$RESULT
	retval="ok"
else
	echo "[WARN] PATH 환경변수에 "." 이 맨 앞이나 중간에 포함되어 있습니다." >>$RESULT
	retval="warning"
	echo "==================================================" >> $RESULT
	echo "1. root 사용자의 PATH 변수 내용입니다." >> $RESULT
	echo "$CHECKPATH" >> $RESULT
	echo "==================================================" >> $RESULT
fi

echo "$retval"
