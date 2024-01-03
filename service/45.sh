#!/bin/bash

. ./util/common.sh

RESULT=./log/45.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-45] tftp, talk 서비스 비활성화" >> $RESULT
echo " [양호] tftp, talk, ntalk 서비스가 비활성화 되어 있는 경우" >> $RESULT
echo " [취약] tftp, talk, ntalk 서비스가 활성화 되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log
> $TMP2
cat << EOF >> $TMP2
tftp
talk
ntalk
EOF
 
result=0

while read DAEMON
do
	ls -l /etc/xinetd.d/$DAEMON >/dev/null 2>&1
	if [ $? -ne 0 ] ; then
		OK "$DAEMON 이 비활성화 되어 있습니다." >>$RESULT
	else
		CHECK=$(cat /etc/xinetd.d/$DAEMON | grep disable | awk -F= '{gsub(/ /, "", $2); print $2}')
	if [ $CHECK = 'yes' ] ; then
		OK "$DAEMON이 비활성화 되어 있습니다." >>$RESULT
	else
		WARN "$DAEMON이 활성화 되어 있습니다." >>$RESULT
		result=$(($result+1))
	fi
fi
done < $TMP2

if [[ "$result" -gt 0 ]] ; then
	WARN "서비스 중 활성화된 서비스가 있습니다.">>$RESULT
	retval="warning"
else
	OK "서비스가 모두 비활성화 되어있습니다.">>$RESULT
	retval="ok"
fi


echo "$retval"
