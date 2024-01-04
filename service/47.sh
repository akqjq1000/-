#!/bin/bash

. ./util/common.sh

RESULT=./log/47.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-31] 스팸 메일 릴레이 제한" >> $RESULT
echo " [양호] SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우" >> $RESULT
echo " [취약] SMTP 서비스를 사용하며 릴레이 제한이 설정되어 있지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP1=./tmp/tmp1.log
TMP2=./tmp/tmp2.log

FILE=/etc/mail/sendmail.cf
 
ps -ef | grep sendmail | grep -v grep 2>/dev/null > /dev/null
 
if [ ! $? = 0 ] ; then
	OK "SMTP서비스를 사용하지 않습니다." >>$RESULT
	retval="ok"
else
	if [ -e "/etc/mail/sendmail.cf" ] ; then
		cat /etc/mail/sendmail.cf | grep -E -v '^#' | grep "R$\*" | grep "Relaying denied" 2>/dev/null>/dev/null
		if [ ! $? = 0 ] ; then
			WARN "SMTP 릴레이 제한이 설정되어 있지 않습니다. ">>$RESULT
			INFO "$FILE 의 Relaying denied 주석을 제거 하고 /etc/mail/access에 지정하십시오.">>$RESULT
			retval="warning"
		else
			OK "SMTP 릴레이 제한이 설정되어 있습니다.">>$RESULT
			retval="ok"
		fi
	else
		WARN "$FILE 파일이 없습니다.">>$RESULT
		retval="warning"
	fi
fi

echo "$retval"
