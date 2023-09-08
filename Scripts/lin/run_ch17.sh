#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter17
LOGFILE=$LOGDIR/@run_ch17_lin.txt

$CHDIR/Ch17_01/Ch17_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE
