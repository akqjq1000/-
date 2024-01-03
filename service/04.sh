#!/bin/bash

RESULT=./log/04.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-04] 패스워드 파일 보호" >> $RESULT
echo " [양호] 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우" >> $RESULT
echo " [취약]  쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

PASSFILE=/etc/passwd
SHADOWFILE=/etc/shadow

CheckEncryptedPasswd() {
SFILE=$1
EncryptedPasswdField=$(grep '^root' $SFILE | awk -F: '{print $2}' | awk -F'$' '{print $2}')
#echo $EncryptedPasswdField
case $EncryptedPasswdField in
	1|2a|5) echo WarnTrue ;;
	6) echo TrueTrue ;;
	*) echo 'None' ;;
esac
}

if [ -f $PASSFILE -a -f $SHADOWFILE ] ; then
	Ret1=$(CheckEncryptedPasswd $SHADOWFILE)
	case $Ret1 in
		None) 
			echo '[WARN] 쉐도우 패스워드를 사용하지만, 패스워드가 암호화 되어 있지 않습니다.' >> $RESULT
			retval="warning"
			;;
		TrueTrue) 
			echo '[OK] 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하고 있습니다.'>>$RESULT
			retval="ok"
			 ;;
		WarnTrue) 
			echo '[OK] 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하고 있습니다.' INFO 'SHA-512 알고리즘을 사용할 것을 권장합니다.'>>$RESULT
			retval="ok"
			;;
		*) : ;;
	esac
else
	echo "[WARN] 쉐도우 패스워드를 사용하지 않고 있습니다." >>$RESULT
	retval="warning"
fi

echo "$retval"
