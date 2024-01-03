#!/bin/bash

RESULT=./log/15.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-54] Session Timeout 설정" >> $RESULT
echo " [양호] Session Timeout이 600초(10분) 이하로 설정되어 있는 경우" >> $RESULT
echo " [취약] Session Timeout이 600초(10분) 이하로 설정되지 않은 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

PASS_FILE=/etc/passwd
TMP2=./tmp/tmp2.log
> $TMP2
 
awk -F: '$3 >= 1000 && $3 <= 60000 {print $1}' $PASS_FILE > $TMP2

for Saram in $(cat $TMP2)
do
	TMOUT_USER=$Saram
	TMOUT_OUTPUT=$(su - $TMOUT_USER -c 'echo $TMOUT' 2>/dev/null)
	if [ -z $TMOUT_OUTPUT ] ; then
		echo "[ WARN ] $TMOUT_USER : not configured" >> $RESULT
	else
		if [ $TMOUT_OUTPUT -le 600 ] ; then
			echo "[ OK ] $TMOUT_USER : $TMOUT_OUTPUT" >> $RESULT
		else
			echo "[ WARN ] $TMOUT_USER : $TMOUT_OUTPUT" >> $RESULT
		fi
	fi
done
 
if grep -q -w WARN $RESULT ; then
	echo "[WARN] Session TimeOut 이 없거나 600초(10분) 이하로 설정되지 않은 경우" >>$RESULT
	retval="warning"
else
	echo "[OK] Session TimeOut 이 없거나 600초(10분) 이하로 설정되어 있는 경우" >>$RESULT
	retval="ok"
fi

echo "$retval"
