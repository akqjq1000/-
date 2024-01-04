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

conf_list=$(find / -type f -name "httpd.conf")

conf_result=0

for conf in $conf_list
do
        cat $conf | grep -v -E "#|^$" | grep Options | grep Indexes 2>/dev/null > /dev/null
        if [ $? -eq 0 ] ; then
                WARN "$conf의 디렉토리 검색 기능이 활성화 되어 있습니다.">>$RESULT
                conf_result=$(($conf_result+1))
        else
                OK "$conf의 디렉토리 검색 기능이 비활성화 되어 있습니다.">>$RESULT
        fi
done

if [[ "$conf_result" -gt 0 ]] ; then
        WARN "디렉토리 검색 기능을 비활성화 해주세요.">>$RESULT
        retval="warning"
else
        OK "디렉토리 검색 기능이 모두 비활성화 되어 있습니다.">>$RESULT
        retval="ok"
fi


echo "$retval"
