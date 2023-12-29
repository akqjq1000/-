#!/bin/bash

# 파일 경로 설정
file_path="./ini/operation.ini"
error=./log/error.log
>$error
process_log=./log/process.log
>$process_log
# 파일의 총 라인 수 가져오기
total_lines=$(wc -l < "$file_path")

# 파일을 1초 간격으로 읽어와서 색상을 변환하여 출력
for ((i = 1; i <= total_lines; i++)); do
    # i번째 라인 읽어오기
    line=$(sed -n "${i}p" "$file_path")

    result=$(echo "${line}" | awk '{print $2}' | tr -d '.')
    if [[ "$result" =~ ^[0-9]+$ ]] ; then
	if retval=$(eval "./service/$result.sh" 2>&1); then
	    echo $retval | tr -d '\n'
	    if [ "$retval" = "ok" ] ; then
		echo -e '\033[32m'"$line"'\033[0m' >> $process_log
		echo -e '\033[32m'"$line"'\033[0m'
	    else
		echo -e '\033[31m'"$line"'\033[0m' >> $process_log
		echo -e '\033[31m'"$line"'\033[0m'
	    fi
	    #sleep 1
	else
	    echo "에러가 발생했습니다 $error 파일을 확인해주세요."
	    echo "$retval" >> $error
	    exit 1
	fi
    else
	echo "${line}" >> $process_log
	echo "${line}"
    fi
done
