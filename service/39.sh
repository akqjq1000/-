#!/bin/bash

. ./util/common.sh

RESULT=./log/39.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-23] DoS 공격에 취약한 서비스 비활성화" >> $RESULT
echo " [양호] 사용하지 않는 DoS 공격에 취약한 서비스가 비활성화 된 경우" >> $RESULT
echo " [취약] 사용하지 않는 DoS 공격에 취약한 서비스가 활성화 된 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log
>$TMP2

find /etc/xinetd.d -type f -name "echo*" -o -name "discard*" -o -name "daytime*" -o -name "chargen*" >> $TMP2

if [ -s $TMP2 ] ; then
	dos_result=0
	while read dir
	do
		disable=$(cat $dir | grep -v -E "^#|^$" | tr -s '\t' ' ' | sed 's/^[ \t]*//' | grep disable | awk -F= '{print $2}' | tr -d ' ')
		if [[ "$disable" == "no" ]] ; then
			dos_result=$(($dos_result+1))
			WARN "$dir 서비스의 disable 속성을 yes로 변경해주세요." >>$RESULT
		else
			OK "$dir 설정이 올바릅니다.">>$RESULT
		fi
	done < $TMP2
	if [[ "$dos_result" -gt 0 ]] ; then
		WARN "각 파일의 disable 설정을 확인해주세요.">>$RESULT
		retval="warning"
	else
		OK "서비스가 모두 비활성화 되어있습니다.">>$RESULT
		retval="ok"
	fi
else
	OK "관련 파일이 없습니다.">>$RESULT
	retval="ok"
fi

echo "$retval"
