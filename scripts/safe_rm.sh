echo -e "\nInstalling a safer version of 'rm' under $HOME/bin ..."
 
mkdir -p $HOME/bin
cd $HOME/bin

cat << EOF > safe_rm
#!/bin/bash
#
 
if [ "\$\#" -eq 0 -o "\$1" = "-h" ]; then
  echo
	echo "You are using a replacement of rm called by an alias."
	echo "To actually delete files or folders use the"
	echo -e "\n--erase parameter like this:"
	echo -e "\nrm --erase -fr myfolder/"
	echo
	exit 0
fi
if [ "\$1" = "--erase" ]; then
	shift
	echo "This will execute: rm \$@"
	read -p "All deleted data are not recoverable. Do you want to proceed (y/n)?"
	if [ "\$REPLY" == "y" ]; then
		/bin/rm \$@
	else
		echo "Aborting..."
		exit 0
	fi
else
	echo "Cowardly refusing to execute rm \$@"
	echo "Use --erase to delete or run rm -h for more info."
fi

EOF

chmod +x safe_rm
cd $HOME

if [ -f $HOME/.bashrc ]; then
  echo "alias rm=$HOME/bin/safe_rm" >> $HOME/.bashrc
  source $HOME/.bashrc
fi
if [ -f $HOME/.zshrc ]; then
  echo "alias rm=$HOME/bin/safe_rm" >> $HOME/.zshrc
  source $HOME/.zshrc
fi
 
echo -e "\nDone.\nYou may need to logout and login again for modifications to take effect."

