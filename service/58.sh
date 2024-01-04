#!/bin/bash

. ./util/common.sh

RESULT=./log/58.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-60] ssh 원격접속 허용" >> $RESULT
echo " [양호] 원격 접속 시 SSH 프로토콜을 사용하는 경우">>$RESULT
echo " ※ ssh, telnet이 동시에 설치되어 있는 경우 취약한 것으로 평가됨" >> $RESULT
echo " [취약] " >> $RESULT
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
                OK "SSHD가 구동중입니다. PID $(pidof sshd)" >> $RESULT
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
                OK "SSHD 서비스가 구동중입니다. PID $ssh_pid">>$RESULT
        fi

        if [[ "$telnet_result" -eq 0 ]] && [[ "$ssh_result" -eq 0 ]] ; then
                retval="ok"
        else
                retval="warning"
        fi
fi


echo "$retval"
