echo "syslog logging" >> /home/$USER/.bashrc
echo "PORT=`who am i | awk '{ print $5 }' | sed 's/(//g' | sed 's/)//g'`" >> /home/$USER/.bashrc
echo "logger -p local7.notice -t "bash $LOGNAME $$" User $LOGNAME logged from $PORT" >> /home/$USER/.bashrc
echo "function history_to_syslog" >> /home/$USER/.bashrc
echo "{" >> /home/$USER/.bashrc
echo "declare cmd" >> /home/$USER/.bashrc
echo "declare p_dir" >> /home/$USER/.bashrc
echo "declare LOG_NAME" >> /home/$USER/.bashrc
echo "cmd=$(history 1)" >> /home/$USER/.bashrc
echo "cmd=$(echo $cmd |awk '{print substr($0,length($1)+2)}')" >> /home/$USER/.bashrc
echo "p_dir=$(pwd)" >> /home/$USER/.bashrc
echo "LOG_NAME=$(echo $LOGNAME)" >> /home/$USER/.bashrc
echo "if [ "$cmd" != "$old_command" ]; then" >> /home/$USER/.bashrc
echo "logger -p local7.notice -- SESSION = $$, from_remote_host = $PORT,  USER = $LOG_NAME,  PWD = $p_dir, CMD =  >> /home/$USER/.bashrc"${cmd}""
echo "fi" >> /home/$USER/.bashrc
echo "old_command=$cmd" >> /home/$USER/.bashrc
echo "}" >> /home/$USER/.bashrc
echo "trap history_to_syslog DEBUG || EXIT" >> /home/$USER/.bashrc
service restart rsyslog
source .bashrc
