#!/bin/bash

RESULT=./log/03.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-03] 계정 잠금 임계값 설정" >> $RESULT
echo " [양호] 계정 잠금 임계값이 10회 이하의 값으로 설정되어 있는 경우" >> $RESULT
echo " [취약] 계정 잠금 임계값이 설정되어 있지 않거나, 10회 이하의 값으로 설정되지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

PAM_FindPatternReturnValue() {
	local PAM_FILE=$1
	local PAM_MODULE=$2
	local PAM_FindPattern=$3
	LINE=$(egrep -v '^#|^$' $PAM_FILE | grep $PAM_MODULE)
	if [ -z "$LINE" ] ; then #내용이 없으면 (zero면) None을 출력
		ReturnValue=None
	else
		PARAMS=$(echo $LINE | cut -d ' ' -f4-)
		# echo $PARAMS
		set $PARAMS
		while [ $# -ge 1 ]
		do
			CHOICE1=$(echo $* | awk '{print $1}' | awk -F= '{print $1}')
			CHOICE2=$(echo $* | awk '{print $1}' | awk -F= '{print $2}')
			# echo "$CHOICE1 : $CHOICE2"
			case $CHOICE1 in
				$PAM_FindPattern) ReturnValue=$CHOICE2 ;;
				*) : ;;		
			esac
			shift
		done
	fi
	echo $ReturnValue
}
pam_system_auth=/etc/pam.d/system-auth

Ret1=$(PAM_FindPatternReturnValue $pam_system_auth pam_tally2.so deny)
Ret2=$(PAM_FindPatternReturnValue $pam_system_auth pam_tally2.so unlock_time)

echo "$Ret1 $Ret2" >> $RESULT
 
if [ "$Ret1" != None -a "$Ret2" != None ] ; then
	if [ $Ret1 -le 10 ] ; then
		echo "[OK] 계정 잠금 임계값이 10 이하의 값으로 설정되어 있는 경우입니다." >> $RESULT
		retval="ok"
	else
		echo "[WARN] 계정 잠금 임계값이 설정되어 있지만, 10 이상의 값으로 설정되어 있습니다." >>$RESULT
		retval="warning"
	fi
else
	echo "[WARN] 계정 잠금 임계값이 설정되어 있지 않거나, 10 이하의 값으로 설정되지 않은 경우 입니다." >>$RESULT
	retval="warning"
fi

echo "$retval"
