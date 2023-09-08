#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter10
LOGFILE=$LOGDIR/@run_ch10_lin.txt

$CHDIR/Ch10_01/Ch10_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch10_02/Ch10_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch10_03/Ch10_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch10_04/Ch10_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch10_05/Ch10_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch10_06/Ch10_06  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

mv @Ch10* $LOGDIR
