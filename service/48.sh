#!/bin/bash

. ./util/common.sh

RESULT=./log/48.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-32] 일반사용자의 Sendmail 실행 방지" >> $RESULT
echo " [양호] SMTP 서비스 미사용 또는, 일반 사용자의 Sendmail 실행 방지가 설정된 경우" >> $RESULT
echo " [취약] SMTP 서비스 사용 및 일반 사용자의 Sendmail 실행 방지가 설정되어 있지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP1=./tmp/tmp1.log
FILE=/etc/mail/sendmail.cf
 
ps -ef | grep sendmail | grep -v grep > $TMP1
 
if [ -z $TMP1 ] ; then
	OK "SMTP서비스를 사용하지 않습니다.">>$RESULT
	retval="ok"
else
	grep -v '^ *#' /etc/mail/sendmail.cf | grep -i privacyoptions \
	| grep restrictqrun >/dev/null 2>&1
 
	if [ $? -eq 0 ] ; then
		OK "일반 사용자의 Sendmail 실행 방지가 설정 되어 있습니다.">>$RESULT
		retval="ok"
	else
		WARN "일반 사용자의 Sendmail 실행 방지가 설정 되어 있지 않습니다.">>$RESULT
		INFO "$FILE1 의 PrivacyOtions에 restrictqrun 옵션을 추가하십시오.">>$RESULT
		retval="warning"
	fi
fi

echo "$retval"
