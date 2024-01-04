#!/bin/bash

. ./util/common.sh

RESULT=./log/61.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-63] ftpusers 파일 소유자 및 권한 설정" >> $RESULT
echo " [양호] ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우" >> $RESULT
echo " [취약]  ftpusers 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

ftpusers_list=$(find / -type f -name "ftpusers" 2> /dev/null)

which stat >/dev/null

ftpusers_result=0

if [ $? = 0 ] ; then
	for ftpusers in $ftpusers_list
	do
	        owner_permission=$(stat -c %a "$ftpusers" | cut -c 1)
	        group_permission=$(stat -c %a "$ftpusers" | cut -c 2)
	        other_permission=$(stat -c %a "$ftpusers" | cut -c 3)

	        CHOWN=$(stat -c %U "$ftpusers")
	        if [ "$CHOWN" = "root" ] ; then
	                if [[ "$owner_permission" -le 6 ]] && [[ "$group_permission" -le 4 ]] && [[ "$others_permission" -le 0 ]]; then
	                        echo "[OK] $ftpusers의 소유자가 root이고 권한이 640이하 입니다.">>$RESULT
	                else
	                        echo "[WARN] $ftpusers의 권한이 644 이상입니다.">>$RESULT
				ftpusers_result=$(($ftpusers_result+1))
        	                ls -l $ftpusers >> $RESULT
	                fi
	       	else
	                echo "[WARN] $ftpusers의 소유자가 root가 아닙니다." >>$RESULT
			ftpusers_result=$(($ftpusers_result+1))
	                ls -l $ftpusers >> $RESULT
	        fi
	done
else
        :
fi

if [[ "$ftpusers_result" -gt 0 ]] ; then
	WARN "파일 소유자 및 권한을 설정해주세요.">>$RESULT
	retval="warning"
else
	OK "파일 소유자 및 권한이 올바르게 설정되어 있습니다.">>$RESULT
	retval="ok"
fi


echo "$retval"
