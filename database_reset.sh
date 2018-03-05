#!/bin/sh
if [ $# -eq 2 ] && [ -f $2 ]
then
	file=$2
else
	echo "Usage $0 user filename"
	exit 1
fi

ORCUSR=$1
ORCPWD=$1
ORCHOST=127.0.0.1:1521/app
CHECK_FILE=CHECK_TABLE_LIST.sql
DROP_FILE=DROP_TABLES.sql
DATE=`date +'%Y%m%d'`
TIME=`date +'%H%M%S'`
LOGS=DATABASE-RESET-$DATE-$TIME.log

echo
echo "User=$ORCUSR"
echo "Passwd=$ORCPWD"
echo "Host=$ORCHOST"
echo

echo "
set echo off;
set verify off;
set heading off;
set feedback off;
set trimspool off;
set linesize 80;
define filename= '$DROP_FILE';
spool &filename;
select ' drop table ' || table_name  || ';' from user_tables;
spool off;
exit;
" > $CHECK_FILE
cat $CHECK_FILE >> $LOGS

echo "sqlplus $ORCUSR/$ORCPWD@$ORCHOST @$CHECK_FILE>> $LOGS 2>&1" >> $LOGS
`sqlplus $ORCUSR/$ORCPWD@$ORCHOST @$CHECK_FILE>> $LOGS 2>&1`
echo "exit;" >> $DROP_FILE

echo "sqlplus $ORCUSR/$ORCPWD@$ORCHOST @$DROP_FILE>> $LOGS 2>&1" >> $LOGS
`sqlplus $ORCUSR/$ORCPWD@$ORCHOST @$DROP_FILE>> $LOGS 2>&1`

echo "imp $ORCUSR/$ORCPWD@$ORCHOST file=$file full=y" >> $LOGS
`imp $ORCUSR/$ORCPWD@$ORCHOST file=$file full=y >> $LOGS 2>&1`

echo "rm -rf $CHECK_FILE $DROP_FILE" >> $LOGS
rm -rf $CHECK_FILE $DROP_FILE