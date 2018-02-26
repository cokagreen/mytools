#!/bin/sh

TABLENAME=userlist


#SRCUSR=usera
#SRCPWD=usera
#SRCHOST=127.0.0.1:1521/


#DSTUSR=userb
#DSTPWD=userb
#DSTHOST=127.0.0.1:1521/
DSTUSR1=
DSTPWD1=
DSTHOST1=

LOGFILE=dblog.log
FILEDIR=./


DATE=$(date '+%Y%m%d')
FILEPATH=$FILEDIR/${TABLENAME}_$DATE.dmp
DOSRCTABLE=.CREATE_TEST.SQL
DODSTTABLE=.DROP_TEST.SQL
if [ $TABLENAME = userlist ] || [ $TABLENAME = USERLIST ]
then
	TABLENAME=USERLIST_TMP
fi
CREATESCRIPT="DROP TABLE ${TABLENAME};\nCREATE TABLE ${TABLENAME} AS SELECT B.BR_NO, A.* FROM USERLIST A, ECI_LEGAL_PERSON_INFO B WHERE A.LEGAL_CODE = B.LEGAL_CODE ORDER BY A.LEGAL_CODE;\nEXIT;\n"
DROPSCRIPT="DROP TABLE ${TABLENAME};\nEXIT;\n"

echo "==============================" >> $LOGFILE
echo '' >> $LOGFILE
if [ ! -f $DOSRCTABLE ]
then
	echo -e $CREATESCRIPT > $DOSRCTABLE
fi

if [ ! -f $DODSTTABLE ]
then
	echo -e $DROPSCRIPT > $DODSTTABLE
fi

echo "==============================" >> $LOGFILE
echo sqlplus $SRCUSR/$SRCPWD@$SRCHOST @$DOSRCTABLE >> $LOGFILE
#`sqlplus $SRCUSR/$SRCPWD@$SRCHOST @$DOSRCTABLE >> $LOGFILE 2>&1`

echo "==============================" >> $LOGFILE
echo exp $SRCUSR/$SRCPWD@$SRCHOST file=$FILEPATH tables=$TABL >> $LOGFILE
#`exp $SRCUSR/$SRCPWD@$SRCHOST file=$FILEPATH tables=$TABLENAME >> $LOGFILE 2>&1`

echo "==============================" >> $LOGFILE
echo sqlplus $DSTUSR/$DSTUSR@$DSTHOST @$DODSTTABLE >> $LOGFILE
#`sqlplus $DSTUSR/$DSTUSR@$DSTHOST @$DODSTTABLE >> $LOGFILE 2>&1`

echo "==============================" >> $LOGFILE
echo imp $DSTUSR/$DSTPWD@$DSTHOST file=$FILEPATH fromuser=$SRCUSR touser=$DSTUSR >> $LOGFILE
#`imp $DSTUSR/$DSTPWD@$DSTHOST file=$FILEPATH fromuser=$SRCUSR touser=$DSTUSR >> $LOGFILE 2>&1`

if [ ! -z $DSTUSR1] && [ ! -z $DSTPWD1 ] && [ ! -z $DSTHOST1 ]
then
	echo "==============================" >> $LOGFILE
	echo imp $DSTUSR1/$DSTPWD1@$DSTHOST1 file=$FILEPATH fromuser=$SRCUSR touser=$DSTUSR >> $LOGFILE
	#`imp $DSTUSR/$DSTPWD@$DSTHOST file=$FILEPATH fromuser=$SRCUSR touser=$DSTUSR >> $LOGFILE 2>&1`
fi
