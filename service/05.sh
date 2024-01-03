#!/bin/bash

RESULT=./log/05.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-44] root 이외의 UID가 ‘0’금지" >> $RESULT
echo " [양호] root 계정과 동일한 UID를 갖는 계정이 존재하지 않는 경우" >> $RESULT
echo " [취약] root 계정과 동일한 UID를 갖는 계정이 존재하는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

PASSFILE=/etc/passwd
result=$(awk -F: '$3 == "0" {print $1}' $PASSFILE)
UIDZEROCNT=$(echo $result | wc -l)
if [[ "$UIDZEROCNT" -ge 2 ]] ; then
	echo '[WARN] root 계정과 동일한 UID를 갖는 계정이 존재합니다' >>$RESULT
	retval="warning"
else
	echo '[OK] root 계정과 동일한 UID를 갖는 계정은 없습니다.'>>$RESULT
	retval="ok"
fi

echo "$retval"
