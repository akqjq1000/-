#!/bin/bash

RESULT=./log/31.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-56] UMASK 설정 관리" >> $RESULT
echo " [양호] UMASK 값이 022 이상으로 설정된 경우" >> $RESULT
echo " [취약] UMASK 값이 022 이상으로 설정되지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

if [[ "$(umask)" -le 0022 ]] ; then
	echo "[OK] UMASK 값이 022 이하로 설정되어 있습니다." >>$RESULT
	echo "$(umask)" >>$RESULT
	retval="ok"
else
	echo "[WARN] UMASK 값이 022 이하로 설정되어 있지 않습니다." >>$RESULT
	echo "[INFO] /etc/bashrc 파일을 수정하십시오." >>$RESULT
	echo "현재 umask는 $(umask)입니다.">>$RESULT
	retval="warning"
fi

echo "$retval"
