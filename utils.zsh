#! /bin/zsh

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
  echo "IN update hosts"
  echo $GITHUB_USER $GITHUB_PW
  line=$(get_sp_hosts_line);
  hosts=$(curl --user "${GITHUB_USER}:${GITHUB_PW}" https://raw.githubusercontent.com/glg/starphleet-enhance/master/regions.txt | cut -d'.' -f1 | tr '\n' ' ')
  replacement=`echo Host  ${hosts}`
  echo ${replacement}
  sed -i.old "${line}s/^.*$/${replacement}/" ~/.ssh/config

}

get_sp_hosts_line() {
  line=$(grep -no starphleet_hosts ~/.ssh/config | cut -d':' -f1);
  line=$((line+1));
  echo ${line}
}

get_sp_hosts_ssh_config() {
  echo $(sed -n "$(get_sp_hosts_line)p" ~/.ssh/config | cut -d' ' -f2-);
}

# deletes a branch from both the local repo and the specified remote
git_delete_branch() {
if [[ $1 == 0 ]] || [[ $2 == 0 ]] ; then
  echo 'You must specify the branch and the remote you wish to delete it from'
  return 0
else
  cd `pwd` && git branch -D $2 && git push $1 :$2
fi;
}

# prunes the branches deleted on the remote and then cleans up local branches associated with those pruned branches
git_prune_local() {
if [ -d .git ]; then
  vared -p "This will delete all local branches where the remote has been removed are you sure you want to continue (y/n)" -c CONT
  if [ "$CONT" == "y" ]; then
  git fetch -p && for branch in `git branch -vv | grep ': gone]' | gawk '{print $1}'`; do git branch -D $branch; done
  git remote | xargs git remote prune
  fi;
else
  echo 'This is not a git repository'
fi;
}

nvmit() {
    if [ -f './.nvmrc' ]; then
        nvm install
    else
        packageJson='./package.json'
        if [ -f $packageJson ]; then
            result=$(jq --raw-output '.engines.node' $packageJson)
            if [ ! -z "$result" ]; then
                nvm install $result
            else
                echo "no engines.node section found in package.json"
            fi
        else
            echo "no package.json found"
        fi
    fi
}