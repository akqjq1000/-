#!/bin/bash

<<<<<<< HEAD
. ./util/common.sh

=======
>>>>>>> 5287d91a8af65f55c780408ec3019ddf2033456a
RESULT=./log/02.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-02] 패스워드 복잡성 설정" >> $RESULT
echo " [양호] 패스워드 최소길이 8자리 이상, 영문·숫자·특수문자 최소 입력 기능이 설정된 경우" >> $RESULT
echo " [취약]  패스워드 최소길이 8자리 이상, 영문·숫자·특수문자 최소 입력 기능이 설정된 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

<<<<<<< HEAD
version=$(getVersion)

if [ "$version" == "5.9" ] || [ "$version" == "5.11" ] || [ "$version" == "6.10" ] ; then
	system_auth=/etc/pam.d/system-auth
	cracklib=$(cat /etc/pam.d/system-auth | grep -v -E "^#|^$" | grep "cracklib.so")
	if [ ! "$cracklib" == "" ] ; then
		minlen=$(cat /etc/pam.d/system-auth | grep -v -E "^#|^$" | grep cracklib.so | sed -n 's/.*minlen=\(-*[0-9]\+\).*/\1/p')
		ucredit=$(cat /etc/pam.d/system-auth | grep -v -E "^#|^$" | grep cracklib.so | sed -n 's/.*ucredit=\(-*[0-9]\+\).*/\1/p')
		lcredit=$(cat /etc/pam.d/system-auth | grep -v -E "^#|^$" | grep cracklib.so | sed -n 's/.*lcredit=\(-*[0-9]\+\).*/\1/p')
		ocredit=$(cat /etc/pam.d/system-auth | grep -v -E "^#|^$" | grep cracklib.so | sed -n 's/.*ocredit=\(-*[0-9]\+\).*/\1/p')
		dcredit=$(cat /etc/pam.d/system-auth | grep -v -E "^#|^$" | grep cracklib.so | sed -n 's/.*dcredit=\(-*[0-9]\+\).*/\1/p')

		if [[ "$minlen" -ge 8 ]] ; then
			if [[ "$lcredit" -eq -1 ]] && [[ "$ocredit" -eq -1 ]] && [[ "$ucredit" -eq -1 ]] && [[ "$dcredit" -eq -1 ]] ; then
				echo "[OK] 영문 숫자 특수문가자 혼합된 8글자 이상의 패스워드를 사용하고 있습니다." >> $RESULT
                                retval="ok"
                        else
                                echo "[WARN] 패스워드가 8글자 이상이지만 dcredit|ucredit|lcredit|ocredit 중 설정이 없는 것이 존재합니>다."  >> $RESULT
				echo "$cracklib" >> $RESULT
				retval="warning"
			fi
		else
			echo '[WARN] 패스워드의 최소 길이 설정이 8글자 미만으로 되어 있음' >> $RESULT	
			echo "$cracklib" >>$RESULT
			retval="warning"
		fi
	else
		echo '[WARN] 아무 설정이 없습니다.' >> $RESULT
		echo $cracklib >> $RESULT
		retval="warning"
	fi
elif [ "$version" == "7.9" ] ; then
        pwquality_conf=/etc/security/pwquality.conf

	VALUE1=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep minlen)
	if [ "$VALUE1" = "" ] ; then
	        echo '[WARN] 패스워드의 최소 길이 설정이 되어있지 않습니다.' >> $RESULT
	        echo "$VALUE1" >> $RESULT
	        retval="warning"
	else
	        minlen=$(cat $pwquality_conf | grep -E -v "^#|^$" | grep minlen | awk -F= '{print $2}' | tr -d ' ')
	        if [ $minlen -ge 8 ] ; then
	                dcredit=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep dcredit | awk -F= '{print $2}' | tr -d ' ')
	                ucredit=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep ucredit | awk -F= '{print $2}' | tr -d ' ')
	                lcredit=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep lcredit | awk -F= '{print $2}' | tr -d ' ')
	                ocredit=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep ocredit | awk -F= '{print $2}' | tr -d ' ')
	                if [ $dcredit -gt 0 -a $ucredit -gt 0 -a $lcredit -gt 0 -a $ocredit -gt 0 ] ; then
	                        echo "[OK] 영문 숫자 특수문가자 혼합된 8글자 이상의 패스워드를 사용하고 있습니다." >> $RESULT
	                        retval="ok"
	                else
	                        echo "[WARN] 패스워드가 8글자 이상이지만 dcredit|ucredit|lcredit|ocredit 중 설정이 없는 것이 존재합니다."  >> $RESULT
	                        cat $pwquality_conf | grep -v -E '^#|^$' >> $RESULT
	                        cat << EOF >> $RESULT
=============================================================
다음은 /etc/security/pwquality.conf 파일을 해석할 때 사용하는 내용입니다.

=======
pwquality_conf=/etc/security/pwquality.conf

VALUE1=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep minlen)
if [ "$VALUE1" = "" ] ; then
	echo '[WARN] 패스워드의 최소 길이 설정이 되어있지 않습니다.' >> $RESULT
	echo "$VALUE1" >> $RESULT
	retval="warning"
else
	minlen=$(cat $pwquality_conf | grep -E -v "^#|^$" | grep minlen | awk -F= '{print $2}' | tr -d ' ')
	if [ $minlen -ge 8 ] ; then
		dcredit=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep dcredit | awk -F= '{print $2}' | tr -d ' ')
		ucredit=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep ucredit | awk -F= '{print $2}' | tr -d ' ')
		lcredit=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep lcredit | awk -F= '{print $2}' | tr -d ' ')
		ocredit=$(cat $pwquality_conf | grep -E -v '^#|^$' | grep ocredit | awk -F= '{print $2}' | tr -d ' ')
		if [ $dcredit -gt 0 -a $ucredit -gt 0 -a $lcredit -gt 0 -a $ocredit -gt 0 ] ; then
			echo "[OK] 영문 숫자 특수문가자 혼합된 8글자 이상의 패스워드를 사용하고 있습니다." >> $RESULT
			retval="ok"
		else
			echo "[WARN] 패스워드가 8글자 이상이지만 dcredit|ucredit|lcredit|ocredit 중 설정이 없는 것이 존재합니다."  >> $RESULT
			cat $pwquality_conf | grep -v -E '^#|^$' >> $RESULT
			cat << EOF >> $RESULT
=============================================================
다음은 /etc/security/pwquality.conf 파일을 해석할 때 사용하는 내용입니다.
 
>>>>>>> 5287d91a8af65f55c780408ec3019ddf2033456a
minlen : 패스워드 최소 길이입니다.
minclass : 패스워드 class 지정입니다.
lcredit : 패스워드 소문자 포함 지정입니다.
ucredit : 패스워드 대문자 포함 지정입니다.
dcredit : 패스워드 숫자 포함 지정입니다.
ocredit : 패스워드 특수문자 포함 지정입니다.
=============================================================
다음은 /etc/security/pwquality.conf 파일의 내용이 없으면,
<<<<<<< HEAD

1) 기본값을 사용하는 경우입니다. 이 경우, 패스워드 정책에 맞지 않습니다.
따라서, 반드시 정책을 변경할 것을 권장합니다.
2) 정책을 변경하는 경우에는 다음과 같은 명령어를 통해 설정할 수 있습니다.
# authconfig --passminlen=8 --passminclass=3
--enablereqlower --disablerequpper --enablereqdigit
--enablereqother --update
=============================================================
EOF
	                        retval="warning"
	                fi
	        else
	                echo '[WARN] 패스워드의 최소 길이 설정이 8글자 미만으로 되어 있음' >> $RESULT
	                echo "$VALUE1" >> $RESULT
	                retval="warning"
	        fi
	fi

fi


=======
 
1) 기본값을 사용하는 경우입니다. 이 경우, 패스워드 정책에 맞지 않습니다. 
따라서, 반드시 정책을 변경할 것을 권장합니다.
2) 정책을 변경하는 경우에는 다음과 같은 명령어를 통해 설정할 수 있습니다.
# authconfig --passminlen=8 --passminclass=3 
--enablereqlower --disablerequpper --enablereqdigit 
--enablereqother --update
=============================================================
EOF
			retval="warning"
		fi
	else
		echo '[WARN] 패스워드의 최소 길이 설정이 8글자 미만으로 되어 있음' >> $RESULT
		echo "$VALUE1" >> $RESULT
		retval="warning"
	fi
fi

>>>>>>> 5287d91a8af65f55c780408ec3019ddf2033456a
echo "$retval"
