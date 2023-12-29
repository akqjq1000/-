#!/bin/bash

RESULT=./log/13.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-52] 동일한 UID 금지" >> $RESULT
echo " [양호] 동일한 UID로 설정된 사용자 계정이 존재하지 않는 경우" >> $RESULT
echo " [취약] 동일한 UID로 설정된 사용자 계정이 존재하는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

TMP2=./tmp/tmp2.log
TMP3=./tmp/tmp3.log
> $TMP2
> $TMP3

PASS_FILE=/etc/passwd
 
awk -F: '{print $3}' $PASS_FILE | sort -n | uniq -d > $TMP2
if [ -s $TMP2 ] ; then # -s =파일의 '사이즈'가 존재하면
	echo '[WARN] 동일한 UID로 설정된 사용자 계정이 존재합니다.' >> $RESULT
	retval="warning"
cat << EOF >> $RESULT
===============================================================
다음 내용은 /etc/passwd 파일의 내용 중 UID가 중복된 사용자의 정보입니다.
ex) $ awk -v CHECK=1001 -F: ' $3 ==CHECK {print \$0}' /etc/passwd
===============================================================
EOF
for Saram in $(cat $TMP2)
do
awk -v CHECK=$Saram -F: '$3 == CHECK {print $0}' $PASS_FILE >> $RESULT
done
else
	echo '[OK] 동일한 UID 로 설정된 사용자 계정이 존재하지 않습니다.' >>$RESULT
	retval="ok"
fi

echo "$retval"
