#!/bin/bash

. ./util/common.sh

RESULT=./log/57.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-41] 웹서비스 영역의 분리" >> $RESULT
echo " [양호] DocumentRoot를 별도의 디렉터리로 지정한 경우" >> $RESULT
echo " [취약] DocumentRoot를 기본 디렉터리로 지정한 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

conf_list=$(find / -type f -name "httpd.conf")

conf_result=0

for conf in $conf_list
do
        cat $conf | grep -v -E "#|^$" | grep -E "/usr/local/apache/htdocs|/usr/local/apache2/htdocs|/var/www/html" 2>/dev/null > /dev/null
        if [ $? -eq 0 ] ; then
                WARN "$conf에 디렉토리가 기본 디렉토리로 지정되어 있습니다.">>$RESULT
                conf_result=$(($conf_result+1))
        else
                OK "$conf에 디렉토리가 별도의 디렉토리로 지정되어 있습니다.">>$RESULT
        fi
done

echo >> $RESULT

if [[ "$conf_result" -gt 0 ]] ; then
        WARN "기본 디렉토리를 /usr/local/apache/htdocs, /usr/local/apache2/htdocs, /usr/www/html 외의 다른 경로로 변경해주세요.">>$RESULT
        retval="warning"
else
        OK "설정이 올바르게 되어 있습니다.">>$RESULT
        retval="ok"
fi


echo "$retval"
