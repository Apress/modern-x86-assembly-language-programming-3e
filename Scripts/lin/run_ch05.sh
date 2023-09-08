#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter05
LOGFILE=$LOGDIR/@run_ch05_lin.txt

$CHDIR/Ch05_01/Ch05_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch05_02/Ch05_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch05_03/Ch05_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch05_04/Ch05_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch05_05/Ch05_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch05_06/Ch05_06  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch05_07/Ch05_07  >>$LOGFILE 2>&1
echo "" >>$LOGFILE
