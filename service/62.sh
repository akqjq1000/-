#!/bin/bash

. ./util/common.sh

RESULT=./log/62.log
>$RESULT

echo "************************************************************************************" >> $RESULT
echo " [U-64] ftpusers 파일 설정(FTP 서비스 root 계정 접근제한)" >> $RESULT
echo " [양호] FTP 서비스가 비활성화 되어 있거나, 활성화 시 root 계정 접속을 차단한 경우" >> $RESULT
echo " [취약] FTP 서비스가 활성화 되어 있고, root 계정 접속을 허용한 경우" >> $RESULT
echo "************************************************************************************" >> $RESULT

retval=""

vsftpd_result=0
proftpd_result=0

ftpusers_list=$(find / -type f -name "ftpusers")
if [ ! "$ftpusers_list" == "" ] ; then
        echo "hh"
        for ftpusers in $ftpusers_list
        do
                cat $ftpusers | grep -v -E "^#|^$" | grep root 2> /dev/null > /dev/null
                if [ $? -eq 0 ] ; then
                        OK "$ftpusers에 root 접근 제한 설정이 되어있습니다.">>$RESULT
                else
                        WARN "$ftpusers에 root 접근 제한이 설정되지 않았습니다.">>$RESULT
                        vsfptd_result=1
                fi
        done
else
        OK "ftpusers 파일이 없습니다.">>$RESULT
fi
proftpd_conf=$(find / -type f -name "proftpd.conf" | grep -v -E "tmp")

if [ ! "$proftpd_conf" == "" ] ; then
        result=$(cat $proftpd_conf | grep -v -E "#|^$" | grep "RootLogin" | awk '{print $2}')

        if [ "$result" == "off" ] ; then
                OK "$proftpd_conf에 root 접근 제한 설정이 되어있습니다.">>$RESULT
        else
                WARN "$proftpd_conf에 root 접근 제한 설정이 되어있지 않습니다.">>$RESULT
                proftpd_result=1
        fi
else
        OK "proftpd.conf파일이 없습니다.">>$RESULT
fi

echo >>$RESULT

if [[ "$vsftpd_result" -gt 0 ]] || [[ "$proftpd_result" -gt 0 ]] ; then
        WARN "ftpusers 파일에 root접근을 제한하는 설정을 해주세요.">>$RESULT
        retval="warning"
else
        OK "설정이 올바르게 되어있습니다.">>$RESULT
        retval="ok"
fi

echo "$retval"

