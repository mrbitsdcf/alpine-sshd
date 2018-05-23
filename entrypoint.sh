#!/bin/sh

# Generate host keys if required
ssh-keygen -A

# Fallback to default SSHD config if none provided
[ ! -f /etc/ssh/sshd_config ] && cp /sshd_config.orig /etc/ssh/sshd_config

# Loop over all USER_xxx env vars, create user accounts as required and assign keys
env | while IFS= read -r var
do
  name=${var%%=*}
  case "$name" in
    PWD_*)
      param=${name##PWD_}
      pwd=${var##*=}
      ;; 
    USER_*)
      username=${name##USER_}
      keys=${var##*=}
      if [ "$username" ] && [ "$keys" ]; then
        case "$keys" in
          http*)
            keys=$(curl -s $keys)
          ;;
        esac
      fi
      if ! id -u "$username" >/dev/null 2>&1; then
        echo "Creating user $username..."
        adduser -D -G xfs -u 1001 -s /bin/ash $username
        passwd -u $username >/dev/null 2>&1;
        echo "${username}:${pwd}" | chpasswd
        chown -R $username:xfs /home/$username
        for dir in .bash_logout .bashrc .profile .ssh ; do
	    rm -f $dir
	done
      fi
      ;;
  esac
done

# Start SSH daemon
exec /usr/sbin/sshd -D -e  "$@"
