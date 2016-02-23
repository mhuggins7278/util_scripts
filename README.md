### Utility Scripts to make life a little easier


##### Installation Instruction
  1. clone the repo
  2. cd into the cloned dir
  3. run the install.sh script
  4. source ~/.bash_profile

#### The Install Script does a couple of things

* Creates ~/.ssh/config if it doesn't exist
* Adds this config section to ~/.ssh/config if it isn't already there
  ```bash
  #starphleet_hosts
  Host virginia ireland singapore jobs staging email elastic notsplunk moserca #list of aliases used to connect
  HostName %h.glgresearch.com # appends the alias name to the full host name when creating the ssh connection
  StrictHostKeyChecking no # don't bother asking to trust these hosts
  UserKnownHostsFile /dev/null # stops writing to the ~/.ssh/known_hosts
  User admiral # always use this user when connecting
  LogLevel ERROR # only log warnings
  ```

  * Adds the following line to ~/.bash_profile
  ```bash
  #Sources the relevant files  
  grep -q -F ${dir} ~/.bash_profile || printf "for f in \`find ${dir}/ -type file ! -name install.sh -and ! -name install.sh\`; do source \$f; done" >> ~/.bash_profile
```
* Alisases Created

   * kp calls the kill_app_by_port function in utils.sh pass it port # and it will the process running on that port ex: ```bash kp 3000 ```

   * sc call the starphleet_connect function in utils.sh updates the list of hosts using https://raw.githubusercontent.com/glg/starphleet-enhance/master/regions.txt and then provides a prompt for you to choose which host to connect to.

     * When calling starphleet_connect we also update the list of available regions from the list above so it should stay in synch.
