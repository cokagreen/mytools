#! /bin/sh

if [ $# -eq 1 ]
then
	home1=$(cat /etc/passwd|grep "\<user1\>"|awk -F: '{print $6}')
	home2=$(cat /etc/passwd|grep "\<user2\>"|awk -F: '{print $6}')
	file1=$(find $home1/work -name $1)
	file2=$(find $home2/work -name $1)
	echo File1: $(cat $file1|wc -l) Lines, $file1
	echo File2: $(cat $file2|wc -l) Lines, $file2
	diff $file1 $file2
else
	echo usage: filediff.sh filename
fi