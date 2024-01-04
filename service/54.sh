#!/bin/bash

. ./util/common.sh

RESULT=./log/54.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-38] 웹서비스 불필요한 파일 제거" >> $RESULT
echo " [양호] 기본으로 생성되는 불필요한 파일 및 디렉터리가 제거되어 있는 경우" >> $RESULT
echo " [취약] 기본으로 생성되는 불필요한 파일 및 디렉터리가 제거되지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

conf_result=0

TMP2=./tmp/tmp2.log
>$TMP2

find / -type f -name "manual" 2> /dev/null > $TMP2

if [ -s $TMP2 ] ; then
	cat $TMP2 >> $RESULT
        WARN "Apache 관련 파일을 제거해주세요.">>$RESULT
        retval="warning"
else
        OK "필요하지 않은 파일이 없습니다. ">>$RESULT
        retval="ok"
fi


echo "$retval"
