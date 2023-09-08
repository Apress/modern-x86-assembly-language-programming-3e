#!/bin/bash
LOGDIR=@results
mkdir -p $LOGDIR
CHDIR=../../Chapter11
LOGFILE=$LOGDIR/@run_ch11_lin.txt

$CHDIR/Ch11_01/Ch11_01   >$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch11_02/Ch11_02  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch11_03/Ch11_03  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch11_04/Ch11_04  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch11_05/Ch11_05  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch11_06/Ch11_06  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch11_07/Ch11_07  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

$CHDIR/Ch11_08/Ch11_08  >>$LOGFILE 2>&1
echo "" >>$LOGFILE

mv @Ch11* $LOGDIR
