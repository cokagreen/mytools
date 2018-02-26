#!/bin/sh
if [ -f $1 ] && [ $# == 1 ]
then
	encode=$(file $1|awk '{print $2}')
	if [ $encode == 'UTF-8' ]
	then 
		iconv -f $encode -t gbk -o $1 $1
		echo 'Encoding: OK'
	else
		echo 'Encoding:' $encode
	fi
else
	echo Usage: $0 filename
fi
