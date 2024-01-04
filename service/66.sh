#!/bin/bash

. ./util/common.sh

RESULT=./log/66.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-68] 로그온 시 경고 메시지 제공" >> $RESULT
echo " [양호] 서버 및 Telnet, FTP, SMTP, DNS 서비스에 로그온 메시지가 설정되어 있는 경우" >> $RESULT
echo " [취약] 서버 및 Telnet, FTP, SMTP, DNS 서비스에 로그온 메시지가 설정되어 있지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log
>$TMP2

cat << EOF >> $TMP2
/etc/motd
/etc/issue.net
/etc/vsftpd/vsftpd.conf
/etc/mail/sendmail.cf
/etc/named.conf
EOF

result=0

while read line
do
	if [ ! -e $line ] ; then
		INFO "$line 배너 설정 파일이 없습니다.">>$RESULT
	else
		counter=$(cat $line | wc -l)
		if [[ "$counter" -gt 0 ]] ; then
			if [ "$line" == "/etc/motd" ] || [ "$line" == "/etc/issue.net" ] ; then
				OK "$line 배너 내용이 있습니다.">>$RESULT
			else
				cat $line | grep -E "ftpd_banner|GreetingMessage" | grep -v -E "#|^$" 2>/dev/null > /dev/null
				if [ $? -eq 0 ] ; then
					INFO "$line의 배너 내용을 확인해주세요">>$RESULT
				else
					WARN "$line에 배너가 설정되지 않았습니다.">>$RESULT
					result=$(($result+1))
				fi
			fi
		else
			WARN "$line 배너 내용이 없습니다.">>$RESULT
			result=$(($result+1))
		fi
	fi	
done <$TMP2

if [[ "$result" -gt 0 ]] ; then
	retval="warning"
else
	retval="ok"
fi

echo "$retval"
