#!/bin/bash

. ./util/common.sh

RESULT=./log/55.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-39] 웹서비스 링크 사용금지" >> $RESULT
echo " [양호] 심볼릭 링크, aliases 사용을 제한한 경우" >> $RESULT
echo " [취약] 심볼릭 링크, aliases 사용을 제한하지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

conf_list=$(find / -type f -name "httpd.conf")

conf_result=0

for conf in $conf_list
do
        cat $conf | grep -v -E "#|^$" | grep Options | grep FollowSymLinks 2>/dev/null > /dev/null
        if [ $? -eq 0 ] ; then
                WARN "$conf의 심볼릭 링크 제한이 되어 있지 않습니다.">>$RESULT
                conf_result=$(($conf_result+1))
        else
                OK "$conf의 심볼릭 링크 제한이 되어 있습니다.">>$RESULT
        fi
done

if [[ "$conf_result" -gt 0 ]] ; then
        WARN "FollowSymLinks를 제거해주세요.">>$RESULT
        retval="warning"
else
        OK "설정이 올바르게 되어 있습니다.">>$RESULT
        retval="ok"
fi


echo "$retval"
