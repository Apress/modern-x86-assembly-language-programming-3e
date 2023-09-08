#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter16
LOGFILE=$LOGDIR/@run_ch16_lin.txt

$CHDIR/Ch16_01/Ch16_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch16_02/Ch16_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch16_03/Ch16_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch16_04/Ch16_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch16_05/Ch16_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

mv @Ch16* $LOGDIR
