#!/bin/bash

. ./util/common.sh

RESULT=./log/56.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-40] 웹서비스 파일 업로드 및 다운로드 제한" >> $RESULT
echo " [양호] 파일 업로드 및 다운로드를 제한한 경우" >> $RESULT
echo " [취약] 파일 업로드 및 다운로드를 제한하지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

conf_list=$(find / -type f -name "httpd.conf")

conf_result=0

TMP2=./tmp/tmp2.log
>$TMP2

for conf in $conf_list
do
        cat $conf | grep -v -E "#|^$" | grep LimitRequestBody 2>/dev/null > $TMP2
	echo $conf >>$RESULT
        if [ -s $TMP2 ] ; then
		while read line
		do
			option=$(echo $line | awk '{print $1}')
			data=$(echo $line | awk '{print $2}')
			if [[ "$data" -le 5000000 ]] ; then
				OK "다운로드 제한이 5M이하로 제한되어 있습니다." >> $RESULT
				INFO "$line" >>$RESULT
			else
				WARN "다운로드 제한이 5M이상입니다.">>$RESULT
                		conf_result=$(($conf_result+1))
			fi	
		done < $TMP2
        else
                WARN "$conf에 파일 다운로드 용량 제한을 설정해주세요.">>$RESULT
                conf_result=$(($conf_result+1))
        fi
done

echo >> $RESULT

if [[ "$conf_result" -gt 0 ]] ; then
        WARN "파일 다운로드 용량 제한 설정을 확인해주세요.">>$RESULT
        retval="warning"
else
        OK "설정이 올바르게 되어 있습니다.">>$RESULT
        retval="ok"
fi


echo "$retval"
