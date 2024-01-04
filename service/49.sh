#!/bin/bash

. ./util/common.sh

RESULT=./log/49.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-33] DNS 보안 버전 패치" >> $RESULT
echo " [양호] DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우" >> $RESULT
echo " [취약] DNS 서비스를 사용하며 주기적으로 패치를 관리하고 있지 않는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

ps -ef | grep -v grep | grep named 2>/dev/null > /dev/null

if [ ! $? -eq 0 ] ; then
	OK "DNS 서비스를 사용하지 않습니다.">>$RESULT
	retval="ok"
else
	WARN "DNS 버전을 확인해주세요.">>$RESULT
	retval="warning"
cat << EOF >> $RESULT
1. BIND는 거의 모든 버전이 취약한 상태로서 최신 버전으로 업데이트가 요구됨
2. 다음은 구체적인 BIND 취약점들이며, 취약점 관련 버전을 사용하는 시스템에서는 버전 업그레이드를 해야 함
 • Inverse Query 취약점 (Buffer Overflow) : BIND 4.9.7이전 버전과 BIND 8.1.2 이전 버전
 • NXT버그 (buffer overflow) : BIND 8.2, 8.2 p1, 8.2.1버전
 • solinger버그 (Denial of Service) : BIND 8.1 이상버전
 • fdmax 버그 (Denial of Service) : BIND 8.1 이상버전
 • Remote Execution of Code(Buffer Overflow) : BIND 4.9.5 to 4.9.10, 8.1, 8.2 to 8.2.6,8.3.0 to 8.3.3 버전
 • Multiple Denial of Service: BIND 8.3.0 - 8.3.3, 8.2 - 8.2.6 버전
 • LIBRESOLV: buffer overrun(Buffer Overflow) : BIND 4.9.2 to 4.9.10 버전
 • OpenSSL (buffer overflow) : BIND 9.1, BIND 9.2 if built with OpenSSL(configure --with-openssl)
 • libbind (buffer overflow) : BIND 4.9.11, 8.2.7, 8.3.4, 9.2.2 이외의 모든 버전
 • DoS internal consistency check (Denial of Service) : BIND 9 ~ 9.2.0 버전
 • tsig bug (Access possible) : BIND 8.2 ~ 8.2.3 버전
 • complain bug (Stack corruption, possible remote access) : BIND 4.9.x 거의 모든 버전
 • zxfr bug (Denial of service) : BIND 8.2.2, 8.2.2 patchlevels 1 through 6 버전
 • sigdiv0 bug (Denial of service) : BIND 8.2, 8.2 patchlevel 1, 8.2.2 버전
 • srv bug(Denial of service): BIND 8.2, 8.2 patchlevel 1, 8.2.1, 8.2.2, 8.2.2 patchlevels 1-6버전
 • nxt bug (Access possible) : BIND 8.2, 8.2 patchlevel 1, 8.2.1 버전
 • BIND 4.9.8 이전 버전, 8.2.3 이전 버전과 관련된 취약점
  - TSIG 핸들링 버퍼오버플로우 취약점
  - nslookupComplain() 버퍼오버플로우 취약점
  - nslookupComplain() input validation 취약점
  - information leak 취약점
  - sig bug Denial of service 취약점
  - naptr bug Denial of service 취약점
  - maxdname bug enial of service 취약점
EOF
fi

echo "$retval"
