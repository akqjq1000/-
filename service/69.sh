#!/bin/bash

. ./util/common.sh

RESULT=./log/69.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-71] Apache 웹 서비스 정보 숨김" >> $RESULT
echo " [양호] ServerTokens Prod, ServerSignature Off로 설정되어있는 경우" >> $RESULT
echo " [취약] ServerTokens Prod, ServerSignature Off로 설정되어있지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

conf_list=$(find / -type f -name "httpd.conf")

TMP2=./tmp/tmp2.log
>$TMP2

result=0

for conf in $conf_list
do
	conf_result=0
        cat $conf | grep -v -E "#|^$" | grep -E "ServerTokens|ServerSignature" 2>/dev/null > $TMP2
        echo $conf >>$RESULT
        if [ -s $TMP2 ] ; then
                while read line
                do
                        option=$(echo $line | awk '{print $1}')
                        data=$(echo $line | awk '{print $2}')
			if [ "$data" == "Prod" ] || [ "$data" == "off" ] ; then
				OK "$conf에 $option 설정이 올바르게 되어있습니다.">>$RESULT
				conf_result=$(($conf_result+1))
			else
				WARN "$conf에 $option 설정을 확인해주세요">>$RESULT
			fi
                done < $TMP2
        else
                WARN "$conf에 ServerTokens나 ServerSignature설정이 없습니다.">>$RESULT
                conf_result=$(($conf_result+1))
        fi
	if [[ ! "$conf_result" -eq 2 ]] ; then
	        WARN "$conf파일에 두 설정을 확인해주세요.">>$RESULT
		result=$(($result+1))
	else
	        OK "$conf의 모두 알맞은 설정이 되어있습니다.">>$RESULT
	fi
done

if [[ "$result" -gt 0 ]] ; then
	retval="warning"
else
	retval="ok"
fi

echo "$retval"
