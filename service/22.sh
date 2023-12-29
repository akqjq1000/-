#!/bin/bash

RESULT=./log/22.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-11] /etc/(r)syslog.conf 파일 소유자 및 권한 설정" >> $RESULT
echo " [양호] /etc/(r)syslog.conf 파일의 소유자가 root(또는 bin, sys)이고, 권한이 640 이하인 경우" >> $RESULT
echo " [취약] /etc/(r)syslog.conf 파일의 소유자가 root(또는 bin, sys)가 아니거나, 권한이 640 이하가 아닌 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

passwd_file="/etc/rsyslog.conf"

which stat >/dev/null

if [ $? = 0 ] ; then
	if [ -f $passwd_file ] ; then
		owner_permission=$(stat -c %a "$passwd_file" | cut -c 1)
		group_permission=$(stat -c %a "$passwd_file" | cut -c 2)
		other_permission=$(stat -c %a "$passwd_file" | cut -c 3)
	
		CHOWN=$(ls -l $passwd_file | awk '{print $3}')
       	 if [ "$CHOWN" = "root" ] || [ "$CHOWN" = "bin" ] || [ "$CHOWN" = "sys" ] ; then
			if [[ "$owner_permission" -le 6 ]] && [[ "$group_permission" -le 4 ]] && [[ "$others_permission" -le 0 ]]; then
				echo "[OK] $passwd_file의 소유자가 root(또는 bin, sys)이고 권한이 640이하 입니다.">>$RESULT
				retval="ok"
			else
				echo "[WARN] $passwd_file의 권한이 640 이상입니다.">>$RESULT
				retval="warning"
				ls -l $passwd_file >> $RESULT
			fi
		else
			echo "[WARN] $passwd_file의 소유자가 root(또는 bin, sys)가 아닙니다." >>$RESULT
			retval="warning"
			ls -l $passwd_file >> $RESULT
		fi
	else
		passwd_file="/etc/syslog.conf"
	        owner_permission=$(stat -c %a "$passwd_file" | cut -c 1)
	        group_permission=$(stat -c %a "$passwd_file" | cut -c 2)
	        other_permission=$(stat -c %a "$passwd_file" | cut -c 3)
	
	        CHOWN=$(ls -l $passwd_file | awk '{print $3}')
	        if [ "$CHOWN" = "root" ] || [ "$CHOWN" = "bin" ] || [ "$CHOWN" = "sys" ] ; then
	                if [[ "$owner_permission" -le 6 ]] && [[ "$group_permission" -le 4 ]] && [[ "$others_permission" -le 0 ]]; then
	                        echo "[OK] $passwd_file의 소유자가 root(또는 bin, sys)이고 권한이 640이하 입니다.">>$RESULT
	                        retval="ok"
	                else
	                        echo "[WARN] $passwd_file의 권한이 640 이상입니다.">>$RESULT
	                        retval="warning"
	                        ls -l $passwd_file >> $RESULT
	                fi
	        else
			echo "[WARN] $passwd_file의 소유자가 root(또는 bin, sys)가 아닙니다." >>$RESULT
	                retval="warning"
	                ls -l $passwd_file >> $RESULT
	        fi
	fi
else
	:
fi

echo "$retval"
