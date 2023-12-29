#!/bin/bash

RESULT=./log/12.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-12] 계정이 존재하지 않는 GID 금지" >> $RESULT
echo " [양호] 시스템 관리나 운용에 불필요한 그룹이 삭제 되어있는 경우" >> $RESULT
echo " [취약] 시스템 관리나 운용에 불필요한 그룹이 존재할 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp1
TMP3=./tmp/tmp2
TMP4=./tmp/tmp3

GROUPFILE=/etc/group
/bin/cp $GROUPFILE $TMP2
for i in $(cat $GROUPFILE | awk -F: '{print $4}')
do
if [ ! -z "$i" ] ; then
sed -i "/:${i}/d" $TMP2
fi
done
 
awk -F: '{print $4}' /etc/passwd > $TMP3
for j in $(cat $TMP2)
do
NUM=$(echo $j | awk -F: '{print $3}')
if grep -wq $NUM $TMP3; then
:
else
echo $j >> $TMP4
fi
done
 
if [ -s $TMP4 ] ; then
	echo "[WARN] 존재하지 않는 계정에 GID 설정이 되어 있습니다.">>$RESULT
	retval="warning"
cat << EOF >> $RESULT
==================================================================
1. 사용자가 포함되지 않은 그룹 이름의 목록을 /etc/group에서 검색하였습니다.
 
$(cat $TMP4)
==================================================================
EOF
else
	echo "[OK] 존재하지 않는 계정에 GID 설정을 금지 되어 있습니다."
	retval="ok"
fi

echo "$retval"
