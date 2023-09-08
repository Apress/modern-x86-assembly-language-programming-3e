#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter02
LOGFILE=$LOGDIR/@run_ch02_lin.txt

$CHDIR/Ch02_01/Ch02_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch02_02/Ch02_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch02_03/Ch02_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch02_04/Ch02_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch02_05/Ch02_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE
