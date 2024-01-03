#!/bin/bash

RESULT=./log/29.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-18] 접속 IP 및 포트 제한" >> $RESULT
echo " [양호] 접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정한 경우" >> $RESULT
echo " [취약] 접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정하지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval="warning"

echo "[WARN] 방화벽 정책을 확인하세요." >>$RESULT
echo "ufw         사용 : ufw show">>$RESULT
echo "firewalld   사용 : firewall-cmd --list-all" >>$RESULT
echo "iptables    사용 : iptables -L" >>$RESULT
echo "TCP Wrapper 사용 : cat /etc/hosts.deny" >>$RESULT

echo "$retval"
