#!/bin/bash

RESULT=./log/19.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-08] /etc/shadow 파일 소유자 및 권한 설정" >> $RESULT
echo " [양호] /etc/shadow 파일의 소유자가 root이고, 권한이 400 이하인 경우" >> $RESULT
echo " [취약] /etc/shadow 파일의 소유자가 root가 아니거나, 권한이 400 이하가 아닌 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

passwd_file="/etc/shadow"

which stat >/dev/null

if [ $? = 0 ] ; then
	owner_permission=$(stat -c %a "$passwd_file" | cut -c 1)
	group_permission=$(stat -c %a "$passwd_file" | cut -c 2)
	other_permission=$(stat -c %a "$passwd_file" | cut -c 3)

	CHOWN=$(ls -l $passwd_file | awk '{print $3}')
        if [ "$CHOWN" = "root" ] ; then
		if [[ "$owner_permission" -le 4 ]] && [[ "$group_permission" -le 0 ]] && [[ "$others_permission" -le 0 ]]; then
			echo "[OK] $passwd_file의 소유자가 root이고 권한이 400이하 입니다.">>$RESULT
			retval="ok"
		else
			echo "[WARN] $passwd_file의 권한이 400 이상입니다.">>$RESULT
			retval="warning"
			ls -l $passwd_file >> $RESULT
		fi
	else
		echo "[WARN] $passwd_file의 소유자가 root가 아닙니다." >>$RESULT
		retval="warning"
		ls -l $passwd_file >> $RESULT
	fi
else
	:
fi

echo "$retval"
