#!/bin/bash

. ./util/common.sh

RESULT=./log/70.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-42] 최신 보안패치 및 벤더 권고사항 적용" >> $RESULT
echo " [양호] 패치 적용 정책을 수립하여 주기적으로 패치관리를 하고 있으며, 패치 관련 내용을 확인하고 적용했을 경우" >> $RESULT
echo " [취약]  패치 적용 정책을 수립하지 않고 주기적으로 패치관리를 하지 않거나 패치 관련 내용을 확인하지 않고 적용하지 않았을 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

cat << EOF >> $RESULT
■ LINUX
LINUX는 서버에 설치된 패치 리스트의 관리가 불가능하므로 rpm 패키지 별 버그가 Fix된 최
신 버전 설치가 필요함
LINUX는 오픈되고, 커스터마이징 된 OS이므로 LINUX를 구입한 벤더에 따라 rpm 패키지가 다
를 수 있으며, 아래의 사이트는 RedHat LINUX에 대한 버그 Fix 관련 사이트임
<Red Hat 일 경우>
Step 1) 다음의 사이트에서 해당 버전을 찾음
 http://www.redhat.com/security/updates/
 http://www.redhat.com/security/updates/eol/ (Red Hat LINUX 9 이하 버전)
Step 2) 발표된 Update 중 현재 사용 중인 보안 관련 Update 찾아 해당 Update Download
Step 3) Update 설치
 #rpm –Uvh <pakage-name>
EOF

retval="warning"

echo "$retval"
