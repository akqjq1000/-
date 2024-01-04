#!/bin/bash

. ./util/common.sh

RESULT=./log/72.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-72] 정책에 따른 시스템 로깅 설정" >> $RESULT
echo " [양호] 로그 기록 정책이 정책에 따라 설정되어 수립되어 있으며 보안정책에 따라 로그를 남기고 있을 경우" >> $RESULT
echo " [취약] 로그 기록 정책 미수립 또는, 정책에 따라 설정되어 있지 않거나 보안정책에 따라 로그를 남기고 있지 않을 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log
>$TMP2

option=(
"*.info;mail.none;authpriv.none;cron.none"
"authpriv.*"
"mail.*"
"cron.*"
"*.alert"
"*.emerg"
)

data=(
"/var/log/messages"
"/var/log/secure"
"/var/log/maillog"
"/var/log/cron"
"/dev/console"
"*"
)

result=0
syslog_conf=""

if [ -e "/etc/syslog.conf" ] ; then
	syslog_conf="/etc/syslog.conf"
elif [ -e "/etc/rsyslog.conf" ] ; then
	syslog_conf="/etc/rsyslog.conf"
else
	WARN "syslog 관련 파일이 없습니다.">>$RESULT
	result=1
fi

if [ ! "$syslog_conf" == "" ] ; then
	for (( i=0 ; i < ${#option[@]}; i++ ))
	do
		re=$(cat $syslog_conf | grep -v -E "^#|^$" | grep "^${option[$i]}" | awk '{print $2}')
		if [ "$re" == "${data[$i]}" ] ; then
			OK "${option[$i]} 설정이 ${data[$i]} 로 되어있습니다.">>$RESULT
		else
			WARN "${option[$i]} 설정을 ${data[$i]}로 설정해주세요.">>$RESULT
			result=$(($result+1))
		fi
	done
fi

if [[ "$result" -gt 0 ]] ; then
	retval="warning"
else
	retval="ok"
fi

echo "$retval"
