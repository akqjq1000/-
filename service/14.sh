#!/bin/bash

RESULT=./log/14.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-53] 사용자 shell 점검" >> $RESULT
echo " [양호] 로그인이 필요하지 않은 계정에 /bin/false(/sbin/nologin) 쉘이 부여되어 있는 경우" >> $RESULT
echo " [취약] 로그인이 필요하지 않은 계정에 /bin/false(/sbin/nologin) 쉘이 부여되지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log
> $TMP2

PASSFILE=/etc/passwd
 
 
# (1) 점검해야 하는 사용자 목록 생성
awk -F: '$3 < 1000 || $3 > 60000 {print $0}' /etc/passwd | egrep -v '^root:|/sbin/nologin|/sbin/false|/sbin/shutdown|/sbin/halt|/bin/sync|/bin/false' | awk -F: '{print $1, $7}' > $TMP2
 
if [ -s $TMP2 ] ; then
	echo "[WARN] 로그인이 필요하지 않은 계정에 로그인 쉘이 부여되어 있습니다.">>$RESULT
	retval="warning"
cat << EOF >> $RESULT
====================================================================
1. 다음 같은 조건을 가진, 로그인 가능 쉘이 부여된 사용자 목록입니다.
* UID 번호가 1 ~ 299 사용자 중 로그인 가능 쉘이 부여된 사용자 목록
* UID 번호가 60001 ~ 65535 사용자 중 로그인 가능 쉘이 부여된 사용자 목록
 
$(cat $TMP2)
====================================================================
EOF
else
	echo "[OK] 로그인이 필요하지 않은 계정에 로그인 쉘이 부여되어 있지 않습니다." >>$RESULT	
	retval="ok"
fi

echo "$retval"
