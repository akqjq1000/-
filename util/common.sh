
OK() {
echo -e '\033[32m'"[ 양호 ] : $*"'\033[0m'
}

WARN() {
echo -e '\033[31m'"[ 취약 ] : $*"'\033[0m'
}

INFO() { 
echo -e '\033[35m'"[ 정보 ] : $*"'\033[0m'
}

CODE(){
echo -e '\033[36m'$*'\033[0m' 
}

getVersion() {
        echo "$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+' | head -n1)"
}

# Function

