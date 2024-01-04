#!/bin/bash

. ./util/common.sh

RESULT=./log/68.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-70] expn, vrfy 명령어 제한" >> $RESULT
echo " [양호] SMTP 서비스 미사용 또는, noexpn, novrfy 옵션이 설정되어 있는 경우" >> $RESULT
echo " [취약] SMTP 서비스를 사용하고, noexpn, novrfy 옵션이 설정되어 있지 않는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

sendmail_cf=/etc/mail/sendmail.cf

if [ -e "$sendmail_cf" ] ; then
	cat $sendmail_cf | grep -v -E "#|^$" | grep PrivacyOptions | grep expn | grep novrfy 2>/dev/null >>$RESULT
	if [ $? -eq 0 ] ; then
		OK "설정이 올바르게 되어있습니다.">>$RESULT
		retval="ok"
	else
		WARN "$sendmail_cf 파일에 PrivacyOptions에 noexpn, novrfy를 추가해주세요.">>$RESULT
		retval="warning"
	fi
else
	OK "sendmail을 사용하지 않습니다">>$RESULT
	retval="ok"
fi

echo "$retval"
