#!/bin/bash

RESULT=./log/11.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-49] 관리자 그룹에 최소한의 계정 포함">> $RESULT
echo " [양호] 관리자 그룹에 불필요한 계정이 등록되어 있지 않은 경우" >> $RESULT
echo " [취약]  관리자 그룹에 불필요한 계정이 등록되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

GROUPFILE=/etc/group
result=$(grep -E '^(root|bin|daemon|sys|adm|tty|disk|mem|kmem|wheel):' $GROUPFILE)
users=$(echo $result | tr ' ' '\n' | awk -F: '{print $4}')

cat << EOF >> $RESULT
==================================================================
1. /etc/group 파일의 내용입니다.
 
* 다음 사항을 점검합니다.
 
* - 1) root,bin,daemon,sys,adm,tty,disk,mem,kmem,wheel 그룹에 속한 사용자가 
반드시 필요한지 고객과 상의한다.
* - 2) 4번째 필드가 그룹에 속한 사용자 목록이다.
* - 3) 사용자 목록이 없으면, 양호이다.
==================================================================
$(echo $result | tr ' ' '\n' | while read line; do user=$(echo $line | awk -F: '{print $4}'); if [ ! "$user" = "" ] ; then echo "$line"; fi; done)
==================================================================
EOF

if [ "$users" = "" ] ; then
	retval="ok"
else
	retval="warning"
fi

echo "$retval"
