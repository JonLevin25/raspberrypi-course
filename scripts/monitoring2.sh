echo "---Syslog Logging---
PORT=`who am i | awk '{ print $5 }' | sed 's/(//g' | sed 's/)//g'`
logger -p local7.notice -t "bash $LOGNAME $$" User $LOGNAME logged from $PORT
function history_to_syslog
{
declare cmd
declare p_dir
declare LOG_NAME
cmd=$(history 1)
cmd=$(echo $cmd |awk '{print substr($0,length($1)+2)}')
p_dir=$(pwd)
LOG_NAME=$(echo $LOGNAME)
if [ "$cmd" != "$old_command" ]; then
logger -p local7.notice -- SESSION = $$, from_remote_host = $PORT,  USER = $LOG_NAME,  PWD = $p_dir, CMD = "${cmd}"
fi
old_command=$cmd
}
trap history_to_syslog DEBUG || EXIT" >> /home/.bashrc
