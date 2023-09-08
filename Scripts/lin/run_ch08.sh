#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter08
LOGFILE=$LOGDIR/@run_ch08_lin.txt

$CHDIR/Ch08_01/Ch08_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch08_02/Ch08_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch08_03/Ch08_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch08_04/Ch08_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch08_05/Ch08_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch08_06/Ch08_06  >>$LOGFILE 2>&1
echo "" >>$LOGFILE
