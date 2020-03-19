#!/bin/zsh
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
conf='#starphleet_hosts
Host virginia ireland singapore jobs staging email elastic notsplunk moserca
HostName %h.glgresearch.com
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
User admiral
LogLevel ERROR'
if [ ! -f ~/.ssh/config ];
then
    touch ~/.ssh/config
fi

if [ -f ~/.ssh/config ];
then
  grep -q -F '#starphleet_hosts' ~/.ssh/config || printf '%s\n' "$conf" >> ~/.ssh/config
fi


grep -q -F ${dir} ~/.zshrc || printf "for f in \`find ${dir}/ -d 1 -type file ! -name install.sh -and ! -name README.md\`; do source \$f; done" >> ~/.zshrc
