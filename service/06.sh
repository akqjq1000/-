#!/bin/bash

RESULT=./log/06.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-] root 계정 su 제한" >> $RESULT
echo " [양호] su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한되어 있는 경우" >> $RESULT
echo " [취약] su 명령어를 모든 사용자가 사용하도록 설정되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

su_permission=$(stat -c %a /usr/bin/su)
su_group=$(stat -c %G /usr/bin/su)

if [ "$su_permission" -le 4750 ] && [ "$su_group" = "wheel" ] ; then
	echo '[INFO] wheel 그룹을 통해 제한하고 있습니다.' >> $RESULT
	echo '[OK] su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한되어 있는 경우입니다.' >> $RESULT
	retval="ok"
else
        if grep -v -E '^#|^$' /etc/pam.d/su | grep -q "pam_wheel.so use_uid" ; then
		echo '[INFO] pam_wheel.so 모듈을 사용하고 있습니다.'>>$RESULT
                if grep -q "wheel" /etc/group; then
			echo '[OK] su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한되어 있는 경우입니다.' >>$RESULT
			retval="ok"
		else
			echo '[INFO] wheel 그룹이 존재하지 않습니다.'>>$RESULT
                fi
        else
                echo "[WARN] su 명령어를 모든 사용자가 사용하도록 설정되어 있는 경우입니다.">>$RESULT
		retval="warning"
        fi
fi

echo "$retval"
