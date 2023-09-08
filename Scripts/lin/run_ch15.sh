#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter15
LOGFILE=$LOGDIR/@run_ch15_lin.txt

$CHDIR/Ch15_01/Ch15_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch15_02/Ch15_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch15_03/Ch15_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch15_04/Ch15_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

mv @Ch15* $LOGDIR
