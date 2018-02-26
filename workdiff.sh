#! /bin/sh

DATE=`date +'%Y%m%d'`
TIME=`date +'%H%M%S'`
LOGS=WOEK-DIFF-$DATE-$TIME.log

gethome(){
	cat /etc/passwd|grep "\<$1\>"|awk -F: '{print $6}'
}

getfilelist(){
	#ls -l $1 | awk '{print $5"\t" split($9,a,"/");print a[0]}'
	ls -l $1 | grep -E ".so$|.xml$|.def$|.pkg$" | awk '{split($9,t,"/");print $5"\t"t[length(t)]}'
}

printfilelist(){
	home=$(gethome $1)
        echo "+..................... $1 .......................+"
	getfilelist $home/work/lib
	getfilelist $home/work/conf
}

main(){
	printfilelist $1 > .diffa.txt
	printfilelist $2 > .diffb.txt
	diff .diffa.txt .diffb.txt 
	cat .diffa.txt > $LOGS
	cat .diffb.txt >> $LOGS
	rm -rf .diffa.txt .diffb.txt
}

if [ $# -eq 2 ]
then
	main $1 $2
else
	echo usage: workdiff.sh user1 user2
fi
