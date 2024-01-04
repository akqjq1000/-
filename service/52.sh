#!/bin/bash

. ./util/common.sh

RESULT=./log/52.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-36] 웹서비스 웹 프로세스 권한 제한" >> $RESULT
echo " [양호] Apache 데몬이 root 권한으로 구동되지 않는 경우" >> $RESULT
echo " [취약] Apache 데몬이 root 권한으로 구동되는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

conf_list=$(find / -type f -name "httpd.conf")

conf_result=0

TMP2=./tmp/tmp2.log
>$TMP2

for conf in $conf_list
do
        cat $conf | grep -v -E "#|^$|%" | grep -E "User|Group" > $TMP2
	while read line
	do
		user=$(echo $line | awk '{print $1}')
		owner=$(echo $line | awk '{print $2}')
		if [ "$owner" == "root" ] ; then
			WARN "$conf의 데몬 구동 권한이 잘못 설정되어 있습니다.">>$RESULT
			echo "$user $owner">>$RESULT
			conf_result=$(($conf_result+1))
		else
			OK "$conf의 데몬 구동 권한이 올바르게 설정되어 있습니다.">>$RESULT
			echo "$user $owner">>$RESULT
		fi
	done < $TMP2
done

if [[ "$conf_result" -gt 0 ]] ; then
        WARN "데몬 구동 권한을 root가 아닌 다른 사용자로 변경해주세요.">>$RESULT
        retval="warning"
else
        OK "데몬 구동 권한이 올바르게 설정되어 있습니다.">>$RESULT
        retval="ok"
fi


echo "$retval"
