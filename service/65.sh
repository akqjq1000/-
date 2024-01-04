#!/bin/bash

. ./util/common.sh

RESULT=./log/65.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-67] SNMP 서비스 Community String의 복잡성 설정" >> $RESULT
echo " [양호] SNMP Community 이름이 public, private 이 아닌 경우" >> $RESULT
echo " [취약] SNMP Community 이름이 public, private 인 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

snmpd_conf_list=$(find / -type f -name "snmpd.conf" | grep -v "/lib")

snmp_result=0

for snmpd_conf in $snmpd_conf_list
do
	echo $snmpd_conf >> $RESULT
	cat $snmpd_conf | grep -v -E "#|^$" | grep -E "public|private" >>$RESULT
	if [ $? -eq 0 ] ; then
		WARN "$snmpd_conf SNMP Community 이름을 public, private이 아닌 다른 이름으로 변경해주세요.">>$RESULT
		snmp_result=$(($snmp_result+1))
	else
		OK "SNMP Community 이름이 기본이 아닙니다.">>$RESULT
	fi
done

echo >>$RESULT

if [[ "$snmp_result" -gt 0 ]] ; then
	retval="warning"
else
	retval="ok"
fi

echo "$retval"
