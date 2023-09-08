#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter09
LOGFILE=$LOGDIR/@run_ch09_lin.txt

$CHDIR/Ch09_01/Ch09_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch09_02/Ch09_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch09_03/Ch09_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch09_04/Ch09_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch09_05/Ch09_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch09_06/Ch09_06  >>$LOGFILE 2>&1
echo "" >>$LOGFILE
