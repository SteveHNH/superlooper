#!/bin/bash
######################################
#            SuperLooper             #
# This script is meant to provide    #
# for a quick way of looping through #
# a text file containing a list of   #
# servers and executing a command.   #
#                                    #
# author: Stephen Adams              #
# email: stephen.adams@duke.edu      #
######################################

# Usage: superlooper.sh <file> 
# example: superlooper.sh 

FILE=$1
OUTFILE=/tmp/`whoami`-`date +"loop-%m%d%Y-%H%M.out"`

if [ -z $1 ]
  then
    echo "Please enter a filename. (ie. superlooper <file>)"
    exit
fi

echo "Script will run against these machines: "
echo `head -10 ${FILE}`
echo "...."
echo " "

echo "Enter your command to execute: "
read COMMAND

echo "Does command require root? (y/n): "
read ANSWER

case ${ANSWER} in
  y)
    echo "Running as Root on all systems"
    for i in `cat ${FILE}` ; do echo "====$i====" >> ${OUTFILE} && ssh -o ConnectTimeout=2 -o LogLevel=QUIET -t $i "sudo ${COMMAND}" >> ${OUTFILE} && echo " " >> ${OUTFILE} ; done
    echo "Command Completed"
    echo "Output Log: ${OUTFILE}"
    exit
  ;;
  n)
    echo "Running as `whoami` on all systems"
    for i in `cat ${FILE}` ; do echo "====$i====" >> ${OUTFILE} && ssh -o ConnectTimeout=2 -o LogLevel=QUIET -t $i "${COMMAND}" >> ${OUTFILE} && echo " " >> ${OUTFILE} ; done
    echo "Command Completed"
    echo "Output Log: ${OUTFILE}"
    exit
  ;;
  *)
    echo "Please choose y or n"
    exit
  ;;
esac


