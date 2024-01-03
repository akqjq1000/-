#!/bin/bash

. ./util/common.sh

RESULT=./log/38.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-22] crond 파일 소유자 및 권한 설정" >> $RESULT
echo " [양호] crontab 명령어 일반사용자 금지 및 cron 관련 파일 640 이하인 경우" >> $RESULT
echo " [취약] crontab 명령어 일반사용자 사용가능하거나, crond 관련 파일 640 이상인 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log
>$TMP2
which stat >/dev/null

if [ $? = 0 ] ; then
	find /etc/cron* -name "cron*" >> $TMP2

	cron_result=0

	while read cron_dir
	do
		owner_permission=$(stat -c %a "$cron_dir" | cut -c 1)
	        group_permission=$(stat -c %a "$cron_dir" | cut -c 2)
	        other_permission=$(stat -c %a "$cron_dir" | cut -c 3)

		CHOWN=$(stat -c %U "$cron_dir")
	        if [ "$CHOWN" = "root" ] ; then
			if [[ "$owner_permission" -le 6 ]] && [[ "$group_permission" -le 4 ]] && [[ "$others_permission" -le 0 ]]; then
				echo "[OK] $cron_dir의 소유자가 root이고 권한이 640이하 입니다.">>$RESULT
			else
				echo "[WARN] $cron_dir의 권한이 640 이상입니다.">>$RESULT
				cron_result=$(($cron_result+1))
				ls -ld $cron_dir >> $RESULT
			fi
		else
			echo "[WARN] $passwd_file의 소유자가 root가 아닙니다." >>$RESULT
			cron_result=$(($cron_result+1))
			ls -l $passwd_file >> $RESULT
		fi
	done <$TMP2
	if [[ "$cron_result" -gt 0 ]] ; then
		WARN "파일의 소유자 및 권한을 확인해주세요." >>$RESULT
		retval="warning"
	else
		OK "파일의 소유자 및 권한이 올바르게 설정되었습니다.">>$RESULT
		retval="ok"
	fi
else
	INFO "사용할 명령어가 없습니다."
fi

echo "$retval"
