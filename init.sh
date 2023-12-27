#!/bin/bash

# 입력 파일
command_list_file=./conf/command.list
service_list_file=./conf/service.list

# 출력 파일
command_list=./ini/command.ini
service_list=./ini/service.ini
>$command_list
>$service_list

echo "*************************************"
echo "*           명령어 점검             *"
echo "*************************************"
echo "* 사용 가능한 명령어를 확인합니다.  *"
echo "* 만약 필요한 명령어가 없을 경우    *"
echo "* 설치하여 진행하거나, 대체 명령어로*"
echo "* 진행합니다.                       *"
echo "*************************************"

# 명령어 리스트에서 각 명령어의 경로를 확인하고 출력 파일에 기록
while read -r command; do
    # which 명령어를 사용하여 경로 확인
    result=$(which "$command" 2>/dev/null)

    # 경로가 존재하는 경우
    if [ -n "$result" ]; then
        echo "$command $result" >> "$command_list"
	echo "$command ok!!"
    else
        # 경로가 없는 경우
        echo "$command none" >> "$service_list"
	echo "$command none"
    fi
done < "$command_list_file"

echo "*************************************"
echo "*          서비스  점검             *"
echo "*************************************"

while read -r service; do
    result=$(systemctl list-unit-files | grep "$service" 2> /dev/null)

    if [ -n "$result" ]; then
        echo "$service $result" >> "$service_list"
        echo "$service ok"
    else
        echo "$service none" >> "$service_list"
        echo "$service none"
    fi
done < "$service_list_file"
