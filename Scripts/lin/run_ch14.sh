#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter14
LOGFILE=$LOGDIR/@run_ch14_lin.txt

$CHDIR/Ch14_01/Ch14_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch14_02/Ch14_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch14_03/Ch14_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch14_04/Ch14_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch14_05/Ch14_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch14_06/Ch14_06  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch14_07/Ch14_07  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch14_08/Ch14_08  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

mv @Ch14* $LOGDIR
