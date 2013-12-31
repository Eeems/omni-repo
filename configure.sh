#!/bin/bash
commands=('expect' 'ssh' 'scp' 'ftp' 'rsync' 'makepkg' 'make' 'git' 'gcc' 'g++' 'repo-add_and_sign');
installed(){
	echo -n -e "Checking for $1...";
	command -v $1 >/dev/null 2>&1 || {
		echo -e "\e[31;01mnot installed\e[0m"; >&2;
		echo "Please install rsync to continue.";
		exit 1;
	};
	echo -e "\e[32;01minstalled\e[0m";
}
# Check to see if all necessary commands exist
for command in "${commands[@]}"; do
	installed $command;
done;
echo "Check done, entering install shell.";
echo -n "Available install commands: ";
ls $(dirname $BASH_SOURCE)/bin/;
bin/install-shell;