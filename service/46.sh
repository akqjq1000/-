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

TMP1=./tmp/tmp1.log
TMP2=./tmp/tmp2.log
>$TMP1
>$TMP2

sendmail_latest_version="sendmail-8.17.2"

INFO "https://ftp.sendmail.org/ 주소를 참조하세요.">>$RESULT
INFO "현재 sendmail의 최신 버전은 $sendmail_latest_version 버전입니다.">>$RESULT

WARN "현재 sendmail 버전은 $(rpm -qa | grep sendmail)이고, 최신 버전은 $sendmail_latest_version입니다.">>$RESULT

retval="warning"

echo "$retval"
