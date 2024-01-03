#!/bin/bash

. ./util/common.sh

RESULT=./log/40.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-40] NFS 서비스 비활성화" >> $RESULT
echo " [양호] 불필요한 NFS 서비스 관련 데몬이 비활성화 되어 있는 경우" >> $RESULT
echo " [취약] 불필요한 NFS 서비스 관련 데몬이 활성화 되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

version=$(getVersion)

if [ "$version" == "5.9" ] || [ "$version" == "5.11" ] || [ "$version" == "6.10" ] ; then
	ps -ef | grep -v -E "grep|kblockd" | grep -E "nfsd|lockd|statd" >> $RESULT
	if [ $? -eq 0 ] ; then
		WARN "nfs 관련 서비스가 구동중입니다.">>$RESULT
		retval="warning"
	else
		OK "nfs 관련 서비스가 비활성화 되어있습니다.">>$RESULT
		retval="ok"
	fi
else
	ps -ef | grep -v -E "grep|kblockd" | grep -E "nfsd|lockd|statd">>$RESULT
	if [ $? -eq 0 ] ; then
                WARN "nfs 관련 서비스가 구동중입니다.">>$RESULT
		retval="warning"
        else
                OK "nfs 관련 서비스가 비활성화 되어있습니다.">>$RESULT
		retval="ok"
        fi
fi

echo "$retval"
