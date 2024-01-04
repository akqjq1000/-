#!/bin/bash

. ./util/common.sh

RESULT=./log/53.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-37] 웹서비스 상위 디렉토리 접근 금지" >> $RESULT
echo " [양호] 상위 디렉터리에 이동제한을 설정한 경우" >> $RESULT
echo " [취약] 상위 디렉터리에 이동제한을 설정하지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

conf_list=$(find / -type f -name "httpd.conf")

conf_result=0

TMP2=./tmp/tmp2.log
>$TMP2

for conf in $conf_list
do
	echo "$conf">>$RESULT
        cat $conf | grep -v -E "#|^$" | grep AllowOverride >$TMP2
	while read line
	do
		allow=$(echo $line | awk '{print $1}')
		data=$(echo $line | awk '{print $2}')
		if [ "$data" == "none" ] || [ "$data" == "None" ] ; then
			WARN "$allow : $data 웹서비스 상위 디렉토리 접근이 가능하게 되어있습니다.">>$RESULT
			conf_result=$(($conf_result+1))
		elif [ "$data" == "AuthConfig" ] || [ "$data" == "AuthName" ] || [ "$data" == "AuthType" ] || [ "$data" == "AuthUserFile" ] || [ "$data" == "AuthGroupFile" ] || [ "$data" == "Require" ]; then
			OK "$allow : $data 올바른 설정값">>$RESULT
		else
			WARN "$allow : $data 잘못된 설정값">>$RESULT
			conf_result=$(($conf_result+1))
		fi
	done <$TMP2
done

if [[ "$conf_result" -gt 0 ]] ; then
        WARN "디렉토리 검색 기능을 비활성화 해주세요.">>$RESULT
        retval="warning"
else
        OK "디렉토리 검색 기능이 모두 비활성화 되어 있습니다.">>$RESULT
        retval="ok"
fi


echo "$retval"
