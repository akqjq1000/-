#!/bin/bash

. ./util/common.sh

RESULT=./log/01.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-01] root 계정 원격 접속 제한" >> $RESULT
echo " [양호] 원격 터미널 서비스를 사용하지 않거나, 사용 시 root 직접 접속을차단한 경우" >> $RESULT
echo " [취약] 원격 터미널 서비스 사용 시 root 직접 접속을 허용한 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

version=$(getVersion)

if [ "$version" == "5.9" ] || [ "$version" == "5.11" ] || [ "$version" == "6.10" ] ; then
	ls -l /etc/xinetd.d/telnet 2> /dev/null > /dev/null
	telnet_result=0
	ssh_result=0
	if [ $? -eq 0 ] ; then
		INFO telnet 서비스 있음! >> $RESULT
		telnet_listen=$(ss -anol | sed -n '/:23 /p')
		if [ ! "$telnet_listen" == "" ] ; then
			WARN telnet 서비스 구동 중 >>$RESULT
			telnet_result=1
		else
			OK telnet 서비스 구동되지 않음 >>$RESULT
		fi
	else
		INFO telnet 서비스 없음 >> $RESULT
	fi
	# SSH 서비스 구동 여부 확인
	ssh_pid=$(/etc/init.d/sshd status | tr -s ' ' | sed -n 's/.*pid \([0-9]\+\).*/\1/p')
	if [[ "$ssh_pid" > 0 ]] ; then
		INFO "SSHD 구동 PID $(pidof sshd)" >> $RESULT
		permit_root_login=$(cat /etc/ssh/sshd_config | grep -E "^PermitRootLogin" | awk '{print $2}')
		if [ "$permit_root_login" = "no" ] ; then
			OK "root 직접 접속이 차단되어 있습니다." >>$RESULT
		else
			WARN "/etc/ssh/sshd_config의 PermitRootLogin을 no로 변경해주세요.">>$RESULT
			ssh_result=1
		fi
	else
		WARN SSHD 서비스가 구동중이지 않습니다.>>$RESULT
		ssh_result=1
	fi

	if [[ "$telnet_result" -eq 0 ]] && [[ "$ssh_result" -eq 0 ]] ; then
		retval="ok"
	else
		retval="warning"
	fi
elif [ "$version" == "7.9" ] ; then
	systemctl list-unit-files | grep telnet.scoket
	telnet_result=0
	ssh_result=0
	if [ $? -eq 0 ] ; then
		INFO "telnet 서비스 있음!" >> $RESULT
		telnet_listen=$(ss -anol | sed -n '/:23 /p')
		if [ ! "$telnet_listen" == "" ] ; then
			WARN "telnet 서비스 구동 중" >>$RESULT
			telnet_result=1
		else
			OK "telnet 서비스 구동되지 않음">>$RESULT
		fi
	else
		INFO "telnet 서비스 없음">>$RESULT
	fi
	ssh_pid=$(pidof sshd)
	if [ "$ssh_pid" == "" ] ; then
		WARN "sshd 서비스가 구동중이지 않습니다.">>$RESULT
		ssh_result=1
	else
		permit_root_login=$(cat /etc/ssh/sshd_config | grep -E "^PermitRootLogin" | awk '{print $2}')
		if [ "$permit_root_login" == "no" ] ; then
			OK "root 직접 접속이 차단되어 있습니다.">>$RESULT
		else
			WARN "/etc/ssh/sshd_config의 PermitRootLogin을 no로 변경해주세요.">>$RESULT
			ssh_result=1
		fi
	fi
	if [[ "$telnet_result" -eq 0 ]] && [[ "$ssh_result" -eq 0 ]] ; then
                retval="ok"
        else
                retval="warning"
        fi
	
fi

echo "$retval"
