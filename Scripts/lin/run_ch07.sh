#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter07
LOGFILE=$LOGDIR/@run_ch07_lin.txt

$CHDIR/Ch07_01/Ch07_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE
