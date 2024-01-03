#!/bin/bash

RESULT=./log/10.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-10] 불필요한 계정 제거" >> $RESULT
echo " [양호] 불필요한 계정이 존재하지 않는 경우" >> $RESULT
echo " [취약] 불필요한 계정이 존재하는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

FILE1=/etc/passwd
echo "[/etc/passwd 파일의 내용]" >> $RESULT
 
cat << EOF >> $RESULT
==================================================================
 
(ㄱ) 시스템 사용자인데 로그인 할 수 있는 쉘을 할당 받은 경우 점검
또한, 시스템 사용자의 정보를 자세하게 확인해야 한다.(악의적인 설정 점검)
 
(ㄴ) 일반사용자 중 최근(최근 1년간)에 로그인한 적이 없는 사용자 점검
이런경우는 lastlog 명령어의 출력 결과를 확인한다.
 
==================================================================
EOF
 
cat /etc/passwd | grep -v -E "/sbin/nologin|/sbin/false|/sbin/shutdown|/sbin/halt|/bin/sync|/bin/false" >> $RESULT
 
 
# lastlog 명령어의 출력 내용
echo >> $RESULT
echo "[lastlog 명령어의 출력내용]" >> $RESULT
 
cat << EOF >> $RESULT
==================================================================
 
(ㄱ) 최근 1년간 로그인한적이 없는 사용자를 점검한다.
(ㄴ) 이 부분은 고객과 반드시 상의해야 한다.
 
==================================================================
EOF
lastlog >> $RESULT
 
 
# su 명령어의 실패 사용자 출력 내용
echo >> $RESULT
echo "[su 명령어의 실패시도 내용]" >> $RESULT
 
cat << EOF >> $RESULT
==================================================================
 
(ㄱ) 빈번하게 su 명령어를 실행하는 사용자들 점검(하루에 20번 이상)
(ㄴ) 일반사용자에서 root 사용자로 전환하는 경우를 중점적으로 점검한다.
 
==================================================================
EOF
 
cat /var/log/secure | grep 'su: pam_unix(su-l:auth): authentication failure' >> $RESULT

retval="warning" 

echo "$retval"
