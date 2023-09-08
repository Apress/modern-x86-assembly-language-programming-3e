#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter12
LOGFILE=$LOGDIR/@run_ch12_lin.txt

$CHDIR/Ch12_01/Ch12_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch12_02/Ch12_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch12_03/Ch12_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch12_04/Ch12_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch12_05/Ch12_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch12_06/Ch12_06  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

mv @Ch12* $LOGDIR
