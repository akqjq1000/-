#!/bin/bash

RESULT=./log/30.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-55] hosts.lpd 파일 소유자 및 권한 설정" >> $RESULT
echo " [양호] hosts.lpd 파일이 삭제되어 있거나 불가피하게 hosts.lpd 파일을 사용할 시 파일의 소유자가 root이고 권한이 600인 경우" >> $RESULT
echo " [취약] hosts.lpd 파일이 삭제되어 있지 않거나 파일의 소유자가 root가 아니고 권한이 600이 아닌 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP1=./log/tmp1.log
>$TMP1
CHECK_FILE="/etc/hosts.lpd"

if [ $? = 0 ] ; then
	if [ -f $CHECK_FILE ] ; then
	        echo "[INFO] $CHECK_FILE 파일이 존재하며 소유자와 권한을 체크합니다.">>$RESULT
	        CHOWN=$(ls -l $CHECK_FILE | awk '{print $3}')
	        if [ $CHOWN = 'root' ] ; then
	                echo "[OK] 파일의 소유자가 root 입니다.">>$RESULT
			owner_permission=$(stat -c %a "$CHECK_FILE" | cut -c 1)
		        group_permission=$(stat -c %a "$CHECK_FILE" | cut -c 2)
		        other_permission=$(stat -c %a "$CHECK_FILE" | cut -c 3)

	                if [[ "$owner_permission" -le 6 ]] && [[ "$group_permission" -le 0 ]] && [[ "$others_permission" -le 0 ]]; then
	                        echo "[OK] $CHECK_FILE의 소유자가 root이고 권한이 600이하 입니다.">>$RESULT
	                        retval="ok"
	                else
	                        echo "[WARN] $CHECK_FILE의 권한이 600 이상입니다.">>$RESULT
	                        retval="warning"
	                        ls -l $CHECK_FILE >> $RESULT
	                fi
	        else
	                echo "[WARN] 파일의 소유자가 root가 아닙니다.">>$RESULT
			retval="warning"
	        fi
	else
        	echo "[INFO] $CHECK_FILE 이 존재하지 않습니다.">>$RESULT
	        echo "[OK] 프린트 서비스를 사용하지 않습니다.">>$RESULT
		retval="ok"
	fi
else
        :
fi

echo "$retval"
