#!/bin/bash

. ./util/common.sh

RESULT=./log/63.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-65] at 서비스 권한 설정" >> $RESULT
echo " [양호] at 명령어 일반사용자 금지 및 at 관련 파일 640 이하인 경우" >> $RESULT
echo " [취약] at 명령어 일반사용자 사용가능하거나, at 관련 파일 640 이상인 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

at_list=$(find /etc -type f -name "at.allow" -o -name "at.deny" | tr ' ' '\n')

at_result=0

if [ "$at_list" == "" ] ; then
	OK "at 설정 파일이 없습니다.">>$RESULT
else
	for at in $at_list
	do
		owner_permission=$(stat -c %a "$at" | cut -c 1)
		group_permission=$(stat -c %a "$at" | cut -c 2)
		other_permission=$(stat -c %a "$at" | cut -c 3)
		CHOWN=$(stat -c %U "$at")
		if [ "$CHOWN" == "root" ] ; then
			if [[ "$owner_permission" -le 6 ]] && [[ "$group_permission" -le 4 ]] && [[ "$other_permission" -le 0 ]] ; then
				OK "$at 파일의 소유자및 권한이 올바르게 설정되었습니다.">>$RESULT
			else
				WARN "$at 파일의 권한을 확인해주세요.">>$RESULT
				ls -l $at>>$RESULT
				at_result=$(($at_result+1))
			fi
		else
			WARN "$at 파일의 소유자가 root가 아닙니다.">>$RESULT
			ls -l $at>>$RESULT
			at_result=$(($at_result+1))
		fi
	done
fi

echo >>$RESULT

if [[ "$at_result" -gt 0 ]] ; then
	WARN "파일의 소유자 및 권한을 확인해주세요.">>$RESULT
	retval="warning"
else
	OK "파일의 소유자 및 권한이 올바릅니다.">>$RESULT
	retval="ok"
fi

echo "$retval"
