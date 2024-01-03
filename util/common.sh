<<<<<<< HEAD
=======
$RESULT=./log/result.log

# Text Line

>>>>>>> 5287d91a8af65f55c780408ec3019ddf2033456a
OK() {
echo -e '\033[32m'"[ 양호 ] : $*"'\033[0m'
} >> $RESULT

WARN() {
echo -e '\033[31m'"[ 취약 ] : $*"'\033[0m'
} >> $RESULT

INFO() { 
echo -e '\033[35m'"[ 정보 ] : $*"'\033[0m'
} >> $RESULT

CODE(){
echo -e '\033[36m'$*'\033[0m' 
} >> $RESULT


<<<<<<< HEAD
getVersion() {
        echo "$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+' | head -n1)"
}
=======
>>>>>>> 5287d91a8af65f55c780408ec3019ddf2033456a


# Function

