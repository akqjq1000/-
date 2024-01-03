#!/bin/bash

RESULT=./log/25.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-14] 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정" >> $RESULT
echo " [양호] 홈 디렉터리 환경변수 파일 소유자가 root 또는, 해당 계정으로 지정되어 있고, 홈 디렉터리 환경변수 파일에 root와 소유자만 쓰기 권한이 부여된 경우" >> $RESULT
echo " [취약] 홈 디렉터리 환경변수 파일 소유자가 root 또는, 해당 계정으로 지정되지 않고, 홈 디렉터리 환경변수 파일에 root와 소유자 외에 쓰기 권한이 부여된 경우" >> $RESULT
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

        ls -al $home 2> /dev/null | grep -E ".profile|.kshrc|.cshrc|.bashrc|.bash_profile|.login|.exrc|.netrc" > $TMP2
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
                echo "[WARN] $user는 $home을 사용하고 있다고 나오지만 존재하지 않는 디렉토리 입니다." >> $RESULT
                retval="warning"
        fi
	cat $TMP2 >> $RESULT
done

echo "$retval"

