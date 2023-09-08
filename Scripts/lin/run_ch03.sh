#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter03
LOGFILE=$LOGDIR/@run_ch03_lin.txt

$CHDIR/Ch03_01/Ch03_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch03_02/Ch03_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch03_03/Ch03_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch03_04/Ch03_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch03_05/Ch03_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE
