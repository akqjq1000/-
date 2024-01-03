#!/bin/bash

RESULT=./log/34.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-59] 숨겨진 파일 및 디렉토리 검색 및 제거" >> $RESULT
echo " [양호] 불필요하거나 의심스러운 숨겨진 파일 및 디렉터리를 삭제한 경우" >> $RESULT
echo " [취약] 불필요하거나 의심스러운 숨겨진 파일 및 디렉터리를 방치한 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval="warning"

TMP2=./tmp/tmp2.log
>$TMP2

find / -name '.*' | grep -v -E ".bashrc|.bash_profile|.bash_history|.bash_logout" > $TMP2

cat $TMP2 | while read filepath;
do
	grep -q "$filepath" ./ini/34.ini
	if [ $? = 1 ] ; then
		echo $filepath >> $RESULT
	fi
done
 
echo "[INFO] $TMP1 (숨김파일 목록) 파일 참고하시기 바랍니다. " >>$RESULT

echo "$retval"
