#!/bin/bash

RESULT=./log/24.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-13] SUID, SGID, 설정 파일점검" >> $RESULT
echo " [양호] 주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우" >> $RESULT
echo " [취약] 주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

find / -xdev -user root -type f -perm -4000 -o -perm -2000 -exec ls -al {} \; > $RESULT

retval="warning"

echo "$retval"
