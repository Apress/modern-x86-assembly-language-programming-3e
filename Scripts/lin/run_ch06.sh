#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter06
LOGFILE=$LOGDIR/@run_ch06_lin.txt

$CHDIR/Ch06_05/Ch06_05  >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch06_06/Ch06_06  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch06_07/Ch06_07  >>$LOGFILE 2>&1
echo "" >>$LOGFILE
