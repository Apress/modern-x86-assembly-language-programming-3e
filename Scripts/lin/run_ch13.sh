#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter13
LOGFILE=$LOGDIR/@run_ch13_lin.txt

$CHDIR/Ch13_01/Ch13_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch13_02/Ch13_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch13_03/Ch13_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch13_04/Ch13_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch13_05/Ch13_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

mv @Ch13* $LOGDIR

