#!/bin/bash

. ./util/common.sh

RESULT=./log/46.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-30] Sendmail 버전 점검" >> $RESULT
echo " [양호] Sendmail 버전이 최신버전인 경우" >> $RESULT
echo " [취약] Sendmail 버전이 최신버전이 아닌 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

version=$(getVersion)

TMP1=./tmp/tmp1.log
TMP2=./tmp/tmp2.log
>$TMP1
>$TMP2


if [ "$version" == "5.11" ] || [ "$version" == "6.10" ] ; then
:
else
	systemctl list-unit-files | grep sendmail >> $TMP1

	if [ $? = 0 ]; then
		ps -ef | grep sendmail | grep -v grep >> $TMP1
		result=$(timeout 1 bash -c "</dev/tcp/localhost/25"&& echo "Port is open" || echo "Port is closed")
		if [ "$result" = "Port is open" ]; then
			timeout 1 bash -c "sendmail -d0.1 -bt > ${TMP2}" 2>/dev/null >/dev/null
			version=$(cat ./tmp/tmp2.log | grep Version | awk '{print $2}')
			last_version=$(yum list sendmail | grep sendmail | awk '{print $2}' | awk -F- '{print $1}')
			INFO 현재 버전은 $version 이고 최신 버전은 $last_version입니다.
		fi
	else
		echo "service not exist"
	fi
fi

echo "$retval"
