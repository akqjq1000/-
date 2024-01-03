#!/bin/bash

. ./util/common.sh

RESULT=./log/36.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-20] Anonymous FTP 비활성화" >> $RESULT
echo " [양호] Anonymous FTP (익명 ftp) 접속을 차단한 경우" >> $RESULT
echo " [취약] Anonymous FTP (익명 ftp) 접속을 차단하지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP1=./tmp/tmp1.log
>$TMP1
TMP2=./tmp/tmp2.log
>$TMP2

grep -q -E "^ftp" /etc/passwd
if [ $? = 0 ] ; then 
	WARN "Anonymous FTP 계정을 사용중입니다.">>$RESULT
	retval="warning"
else
	vsftpd_result=0
	proftpd_result=0
	vsftpd_conf=/etc/vsftpd/vsftpd.conf
	proftpd_conf=/etc/proftpd.conf
	if [ -e "$vsftpd_conf" ] ; then
		anonymous_enable=$(cat /etc/vsftpd/vsftpd.conf | grep -v -E "^#|^$" | grep anonymous_enable | awk -F= '{print $2}')
		if [ "$anonymous_enable" == "YES" ] ; then
			vsftpd_result=1
		fi
	else
		OK "vsftpd 서비스 설정 파일 /etc/vsftpd/vsftpd.conf이 없습니다."
	fi
	if [ -e "$proftpd_conf" ] ; then
		awk '/<Anonymous ~ftp>/,/<\/Anonymous>/' /etc/proftpd.conf | tr -s '\t' | tr -s ' ' | sed 's/^[[:space:]]*//' | grep -v -E "^#|^$|UserAlias" | grep -E "^User|^Group" >> $TMP2
		while read user group
		do
			if [ "$group" == "ftp" ]; then
				proftpd_result=$(($proftpd+1))
			fi
		done < $TMP2
	else
		OK "proftpd 서비스 설정 파일 /etc/proftpd.conf이 없습니다." >>$RESULT
	fi
	if [[ "vsftpd_result" -gt 0 ]] ; then
		WARN "vsftpd 설정 파일에 Anonymous FTP 허용 설정이 있습니다.">>$RESULT
	else
		OK "vsftpd 설정 파일에 Anonymous FTP 허용 설정이 없습니다.">>$RESULT
	fi

	if [[ "$proftpd_result" -gt 0 ]] ; then
		WARN "proftpd 설정 파일에 Anonymous FTP 허용 설정이 있습니다.">>$RESULT
	else
		OK "proftpd 설정 파일에 Anonymous FTP 허용 설정이 없습니다.">>$RESULT
	fi

	if [[ "$proftpd_result" -gt 0 ]] || [[ "$vsftpd_result" -gt 0 ]] ; then
		retval="warning"
	else
		retval="ok"
	fi
fi

echo "$retval"
