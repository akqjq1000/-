#!/bin/bash

. ./util/common.sh

RESULT=./log/37.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-21] r 계열 서비스 비활성화" >> $RESULT
echo " [양호] 불필요한 r 계열 서비스가 비활성화 되어 있는 경우" >> $RESULT
echo " [취약] 불필요한 r 계열 서비스가 활성화 되어 있는 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

version=$(getVersion)

if [ "$version" == "5.9" ] || [ "$version" == "5.11" ] || [ "$version" == "6.10" ] ; then
	rlogin_conf=/etc/xinetd.d/rlogin
	rsh_conf=/etc/xinetd.d/rsh
	rexec_conf=/etc/xinetd.d/rexec

	rlogin_result=0
	rsh_result=0
	rexec_result=0

	if [ -e "$rlogin_conf" ] ; then
		disable=$(cat /etc/xinetd.d/rlogin | grep -v -E "^#|^$" | tr -s '\t' ' ' | sed 's/^[ \t]*//' | grep disable | awk -F= '{print $2}' | tr -d ' ')
		if [ "$disable" == "no" ] ; then
			WARN "rlogin disable 설정을 yes로 변경해주세요." >>$RESULT
			rlogin_result=1
		else
			OK "rlogin은 disable로 설정되어 있습니다.">>$RESULT
		fi
	else
		OK "rlogin 서비스를 사용하지 않습니다.">>$RESULT
	fi
	if [ -e "$rsh_conf" ] ; then
	        disable=$(cat /etc/xinetd.d/rsh | grep -v -E "^#|^$" | tr -s '\t' ' ' | sed 's/^[ \t]*//' | grep disable | awk -F= '{print $2}' | tr -d ' ')
                if [ "$disable" == "no" ] ; then
                        WARN "rsh disable 설정을 yes로 변경해주세요.">>$RESULT
                        rsh_result=1
                else
                        OK "rsh은 disable로 설정되어 있습니다.">>$RESULT
                fi
        else
                OK "rsh 서비스를 사용하지 않습니다.">>$RESULT
	fi
	if [ -e "$rexec_conf" ] ; then
	        disable=$(cat /etc/xinetd.d/rexec | grep -v -E "^#|^$" | tr -s '\t' ' ' | sed 's/^[ \t]*//' | grep disable | awk -F= '{print $2}' | tr -d ' ')
                if [ "$disable" == "no" ] ; then
                        WARN "rexec disable 설정을 yes로 변경해주세요.">>$RESULT
                        rexec_result=1
                else
                        OK "rexecn은 disable로 설정되어 있습니다.">>$RESULT
                fi
        else
                OK "rexec 서비스를 사용하지 않습니다.">>$RESULT
	fi
	
	if [[ "$rlogin_result" -gt 0 ]] || [[ "$rsh_result" -gt 0 ]] || [[ "$rexec_result" -gt 0 ]] ; then
		WARN "r 계열 서비스가 활성화 되어있습니다. 확인해주세요">>$RESULT
		retval="warning"
	else
		OK "r 계열 서비스가 모두 비활성화 되어있습니다.">>$RESULT
		retval="ok"
	fi
elif [ "$version" == "7.9" ] ; then
	service_rsh=$(systemctl is-active rsh.socket)
	service_rlogin=$(systemctl is-active rlogin.socket)
	service_rexec=$(systemctl is-active rexec.socket)
	rsh_result=0
	rlogin_result=0
	rexec_result=0
	if [ "$service_rsh" == "active" ]; then
		WARN "rsh 서비스가 구동중입니다.">>$RESULT
		rsh_result=1
	else
		OK "rsh 서비스가 종료되어 있습니다.">>$RESULT
	fi
	if [ "$service_rlogin" == "active" ] ; then
		WARN "rlogin 서비스가 구동중입니다.">>$RESULT
		rlogin_result=1
	else
		OK "rlogin 서비스가 종료되어 있습니다.">>$RESULT
	fi
	if [ "$service_rexec" == "active" ] ; then
		WARN "rexec 서비스가 구동중입니다.">>$RESULT
		rexec_result=1
	else
		OK "rexec 서비스가 종료되어 있습니다.">>$RESULT
	fi
	if [[ "$rsh_result" -gt 0 ]] || [[ "$rlogin_result" -gt 0 ]] || [[ "$rexec_result" -gt 0 ]] ; then
		WARN "r 계열 서비스가 구동되어 있습니다. 종료해주세요.">>$RESULT
		retval="warning"
	else
		OK "r 계열 서비스가 종료되어 있습니다.">>$RESULT
		retval="ok"
	fi
fi

echo "$retval"
