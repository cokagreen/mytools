#! /bin/bash

getfile(){
	# $1 user; $2 filename
	home=$(cat /etc/passwd|grep "\<$1\>"|awk -F: '{print $6}')
	filelist=($(find $home/work -name $2))
	listlen=${#filelist[*]}
	if [ $listlen -eq 1 ]
	then
                file=${filelist[0]}
        elif [ $listlen -gt 1 ]
	then
		echo "$1 has ${#filelist[*]} files named \"$2\", please choose one."
		i=0
		for f in ${filelist[*]}
		do
			echo "[$i] $f"
			((i++))
		done
		read -p "your choose is($1): " num
		until [ $num -gt 0 ] 2>/dev/null && [ $num -lt $listlen ] 
		do
			read -p "please choose again($1): " num
		done
		file=${filelist[$num]}
	else
		file="error"
	fi
	result=$file
}

if [ $# -eq 1 ]
then
	getfile user1 $1
	file1=$result
	getfile user2 $1
	file2=$result

	echo File: $(cat $file1|wc -l) Lines, $file1
	echo File: $(cat $file2|wc -l) Lines, $file2
	diff $file1 $file2
else
	echo usage: workdiff.sh file
fi
