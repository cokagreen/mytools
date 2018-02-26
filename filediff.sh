#! /bin/bash

if [ $# -eq 1 ]
then
	home1=$(cat /etc/passwd|grep "\<user1\>"|awk -F: '{print $6}')
	home2=$(cat /etc/passwd|grep "\<user2\>"|awk -F: '{print $6}')
	filelist1=($(find $home1/work -name $1))
	filelist2=($(find $home2/work -name $1))
	file1=${filelist1[0]}
	if [ ${#filelist2[*]} -eq 1 ]
	then
		file2=${filelist2[0]}
	else
		echo "user2 has ${#filelist2[*]} files named \"$1\", please choose one."
		i=0
		for f in ${filelist2[*]}
		do
			echo "[$i] $f"
			((i++))
		done
		read -p "your choose is: " num
		until [ $num -gt 0 ] 2>/dev/null && [ $num -lt ${#filelist2[*]} ] 
		do
			read -p "please choose again: " num
		done
		file2=${filelist2[$num]}
	fi
	echo File1: $(cat $file1|wc -l) Lines, $file1
	echo File2: $(cat $file2|wc -l) Lines, $file2
	diff $file1 $file2
else
	echo usage: workdiff.sh file
fi
