
kill_app_by_port() {
if [[ $1 -eq 0 ]] ; then
  echo 'You must specify the port -ex kill_app_by_port 3000'
  return 0
fi
echo  'Killing ' $1
lsof -n -a -iTCP:$1 -sTCP:LISTEN -t | xargs kill
}


starphleet_connect() {
  update_starphleet_hosts > /dev/null 2>&1 && select region in $(get_sp_hosts_ssh_config); do
     [ -z "${region}" ] && return 0
     ssh ${region}
     break;
  done
}

update_starphleet_hosts() {
  line=$(get_sp_hosts_line);
  hosts=$(curl https://raw.githubusercontent.com/glg/starphleet-enhance/master/regions.txt | cut -d'.' -f1)
  replacement=`echo Host  ${hosts// / }`
  sed -i.old "${line}s/^.*$/${replacement}/" ~/.ssh/config

}

get_sp_hosts_line(){
  line=$(grep -no starphleet_hosts ~/.ssh/config | cut -d':' -f1);
  line=$((line+1));
  echo ${line}
}

get_sp_hosts_ssh_config(){
  echo $(sed -n "$(get_sp_hosts_line)p" ~/.ssh/config | cut -d' ' -f2-);
}
