#!/bin/bash

RESULT=./log/17.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-06] 파일 및 디렉터리 소유자 설정" >> $RESULT
echo " [양호] 소유자가 존재하지 않는 파일 및 디렉터리가 존재하지 않는 경우" >> $RESULT
echo " [취약] 소유자가 존재하지 않는 파일 및 디렉터리가 존재하는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log

find / \( -nouser -o -nogroup \) -ls 2>/dev/null >$TMP2

if [ -s $TMP2 ] ; then
	echo "[WARN] 소유자가 존재하지 않은 파일 및 디렉토리가 있습니다." >>$RESULT	
	retval="warning"
	echo "다음 명령어가 실행된 출력 결과입니다." >> $RESULT
	echo 'CMD : find / \( -nouser -o -nogroup \) -ls 2>/dev/null' >> $RESULT
	echo "======================================================" >> $RESULT
	cat $TMP2 >> $RESULT
else
	echo "[OK] 소유자가 존재하지 않은 파일 및 디렉토리가 없습니다.">>$RESULT
	retval="ok"
fi

echo "$retval"
