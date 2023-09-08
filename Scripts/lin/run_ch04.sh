#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter04
LOGFILE=$LOGDIR/@run_ch04_lin.txt

$CHDIR/Ch04_01/Ch04_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch04_02/Ch04_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch04_03/Ch04_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch04_04/Ch04_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch04_05/Ch04_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch04_06/Ch04_06  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch04_07/Ch04_07  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch04_08/Ch04_08  >>$LOGFILE 2>&1
echo "" >>$LOGFILE
