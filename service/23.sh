#!/bin/bash

RESULT=./log/23.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-12] /etc/services 파일 소유자 및 권한 설정" >> $RESULT
echo " [양호] /etc/services 파일의 소유자가 root(또는 bin, sys)이고, 권한이 644 이하인 경우" >> $RESULT
echo " [취약] /etc/services 파일의 소유자가 root(또는 bin, sys)가 아니거나, 권한이 644 이하가 아닌 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

passwd_file="/etc/services"

which stat >/dev/null

if [ $? = 0 ] ; then
	owner_permission=$(stat -c %a "$passwd_file" | cut -c 1)
	group_permission=$(stat -c %a "$passwd_file" | cut -c 2)
	other_permission=$(stat -c %a "$passwd_file" | cut -c 3)

	CHOWN=$(ls -l $passwd_file | awk '{print $3}')
        if [ "$CHOWN" = "root" ] || [ "$CHOWN" = "bin" ] || [ "$CHOWN" = "sys" ]; then
		if [[ "$owner_permission" -le 6 ]] && [[ "$group_permission" -le 4 ]] && [[ "$others_permission" -le 4 ]]; then
			echo "[OK] $passwd_file의 소유자가 root(또는 bin, sys)이고 권한이 644이하 입니다.">>$RESULT
			retval="ok"
		else
			echo "[WARN] $passwd_file의 권한이 644 이상입니다.">>$RESULT
			retval="warning"
			ls -l $passwd_file >> $RESULT
		fi
	else
		echo "[WARN] $passwd_file의 소유자가 root(또는 bin, sys)가 아닙니다." >>$RESULT
		retval="warning"
		ls -l $passwd_file >> $RESULT
	fi
else
	:
fi

echo "$retval"
