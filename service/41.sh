#!/bin/bash

. ./util/common.sh

RESULT=./log/41.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-25] NFS 접근 통제" >> $RESULT
echo " [양호] 불필요한 NFS 서비스를 사용하지 않거나, 불가피하게 사용 시 everyone 공유를 제한한 경우" >> $RESULT
echo " [취약] 불필요한 NFS 서비스를 사용하고 있고, everyone 공유를 제한하지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

cat /etc/exports | grep -v -E "^#|^$" | grep -E "no_root_squash|insecure|rw" >> $RESULT

if [ $? -eq 0 ] ; then
	WARN "설정 중 no_root_squash, insecure, rw 설정이 포함되어 있습니다." >>$RESULT
	retval="warning"
else
	OK "설정이 올바르게 되어있습니다.">>$RESULT
	retval="ok"
fi

echo "$retval"
