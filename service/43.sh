#!/bin/bash

. ./util/common.sh

RESULT=./log/43.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-27] RPC 서비스 확인" >> $RESULT
echo " [양호] 불필요한 RPC 서비스가 비활성화 되어 있는 경우" >> $RESULT
echo " [취약] 불필요한 RPC 서비스가 활성화 되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log
>$TMP2

cat << EOF >> $TMP2
rpc.cmsd
cmsd
rpc.ttdbserverd
ttdbserverd
sadmind
rusersd
walld
sparayd
rstatd
rpc.nisd
rexd
rpc.pcnfsd
pcnsfd
rpc.statd
rpc.ypupdated
rqotad
kcms_server
cachefsd
EOF

rpc_result=0

for rpc_service in $(cat $TMP2)
do
	ls -ld /etc/xinetd.d/$rpc_service* 2>/dev/null
	if [ ! $? -eq 0 ] ; then
		OK "/etc/xinetd.d/$rpc_service 파일이 존재하지 않습니다.">>$RESULT
	else
		for rpc in $(ls /etc/xinetd.d/$rpc_service*)
		do
			if [ $(cat $rpc | grep disable | awk '{print $3}') == "yes" ] ; then
				OK "$rpc 파일에 대한 서비스가 비활성화 되어있습니다.">>$RESULT
			else
				WARN "$rpc 파일에 대한 서비스가 활성화 되어있습니다.">>$RESULT
				rpc_result=$(($rpc_result+1))
			fi
		done
	fi
done

if [[ "$rpc_result" -gt 0 ]] ; then
	WARN "RPC 서비스 확인이 필요합니다.">>$RESULT
	retval="warning"
else
	OK "불필요 RPC 서비스가 모두 비활성화 되어있습니다.">>$RESULT
	retval="ok"
fi

echo "$retval"
