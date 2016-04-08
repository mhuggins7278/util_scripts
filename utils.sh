
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
  hosts=$(curl --user "${GITHUB_USER}:${GITHUB_PW}" https://raw.githubusercontent.com/glg/starphleet-enhance/master/regions.txt | cut -d'.' -f1)
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

#sfd
#
#  loop through each directory in the starphleet_dev dir and check for a .git dir
#  and if it is a git repo, open these as unique roots in a single atom window
sfd() {
    cd ${HOME}/starphleet_dev
    LIST=""
    for dir in $(find ${HOME}/starphleet_dev -type d -maxdepth 2); do
      [ -d "$dir/.git" ] && LIST="${LIST} ${dir}"
    done
    echo Opening ${LIST}
    # Expand the ${LIST} before running the command with eval
    eval atom ${LIST}
}
#gbd
#
# deletes a branch from both the local repo and the specified remote
gbd() {
if [[ $1 == 0 ]] || [[ $2 == 0 ]] ; then
  echo 'You must specify the branch and the remote you wish to delete it from'
  return 0
fi
  cd `pwd` && git branch -D $2 && git push $1 :$2
}
