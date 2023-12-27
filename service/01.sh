#!/bin/bash

RESULT=./log/01.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-01] root 계정 원격 접속 제한" >> $RESULT
echo " [양호] 원격 터미널 서비스를 사용하지 않거나, 사용 시 root 직접 접속을차단한 경우" >> $RESULT
echo " [취약] 원격 터미널 서비스 사용 시 root 직접 접속을 허용한 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TELNET_SERVICE=telnet.socket
SECURETTY=/etc/securetty
STATUS1=$(systemctl is-active $TELNET_SERVICE)
SSH_SERVICE=sshd.service
SSH_CONFIG=/etc/ssh/sshd_config
STATUS2=$(systemctl is-active $SSH_SERVICE)

if [ $STATUS1 = 'active' ] ; then
	echo 'Service is activated. You must Turn off the Service!' >> $RESULT
	if [ -f $SECURETTY ] ; then
		grep -q 'pts/' $SECURETTY # -q no output. only 0 or 1
		if [ $? -eq 0 ] ; then
			echo '[WARN] /etc/securetty 파일안에 pts/# 존재합니다' >> $RESULT
			retval="warning"
		else
			echo '[OK] /etc/securetty 파일안에 pts/# 존재하지 않습니다' >> $RESULT
			retval="ok"
		fi
	else
		echo '/etc/securetty 파일이 존재하지 않습니다' >> $RESULT
	fi
else
	if [ $STATUS2 = 'active' ] ; then
		if [ -f $SSH_CONFIG ] ; then
			grep -q -E '^PermitRootLogin no' /etc/ssh/sshd_config
			if [ $? -eq 1 ] ; then
				echo '[WARN] /etc/ssh/sshd_config 파일에 PermitRootLogin 설정을 확인해주세요.' >> $RESULT
				retval="warning"
			else
				echo '[OK] /etc/ssh/sshd_config 파일에 PermitRootLogin이 no로 설정되어 있습니다.' >> $RESULT
				retval="ok"
			fi
		else
			echo '설정 파일의 경로를 확인해주세요.' >> $RESULT
		fi
	else
		WARN 'SSH 서비스가 실행중이지 않습니다.' >> $RESULT
	fi
fi
echo "$retval"
