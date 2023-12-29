#!/bin/bash

RESULT=./log/28.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-17] $HOME/.rhosts, hosts.equiv 사용 금지" >> $RESULT
echo " [양호] login, shell, exec 서비스를 사용하지 않거나, 사용 시 아래와 같은 설정이 적용된 경우" >> $RESULT
echo "        1. /etc/hosts.equiv 및 $HOME/.rhosts 파일 소유자가 root 또는, 해당 계정인 경우" >> $RESULT
echo "        2. /etc/hosts.equiv 및 $HOME/.rhosts 파일 권한이 600 이하인 경우" >> $RESULT
echo "        3. /etc/hosts.equiv 및 $HOME/.rhosts 파일 설정에 ‘+’ 설정이 없는 경우" >> $RESULT
echo " [취약] login, shell, exec 서비스를 사용하고, 위와 같은 설정이 적용되지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

TMP1=./tmp/tmp1.log
>$TMP1
TMP2=./tmp/tmp2.log
>$TMP2

retval=""

retval="ok"

cat /etc/passwd | grep -v -E "/sbin/nologin|/sbin/false|/bin/false|^#" | awk -F: '$3 >= 500 && $3 < 60000 {print $1":"$6}'>$TMP1

for line in `cat $TMP1`
do
	user=$(echo $line | awk -F: '{print $1}')
	home=$(echo $line | awk -F: '{print $2}')

        ls -al $home/.rhosts 2> /dev/null > $TMP2
        if [ -s "$TMP2" ] ; then
		owners=$(cat $TMP2 | awk '{print $3}')
		for owner in $owners
		do
			if [ "$user" == "$owner" ] ; then
				echo "[OK] $user 사용자의 설정 파일의 소유자가 일치합니다." >> $RESULT
			else
				echo "[WARN] $user 사용자의 설정 파일 소유자가 일치하지 않습니다." >> $RESULT
				retval="warning"
			fi
		done
        else
                echo "[OK] $user는 .rhosts 파일을 사용하지 않습니다." >> $RESULT
                retval="ok"
        fi
	cat $TMP2 >> $RESULT
done

echo "$retval"

