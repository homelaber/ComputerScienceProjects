#! /bin/bash

# test if we're root
if [ "$UID" -eq 0 ] ; then
  echo "Running with root priveleges"
else
  echo "Ordinary user, exiting"
  exit 1
fi

# test for installed dependencies
dependencies=(pvresize lvextend resize2fs)
for i in "${dependencies[@]}"
do
  command -v $i >/dev/null 2>&1 || { echo >&2 "I require $i but it's not installed.  Aborting."; exit 1; }
done

# test for CLI arguments
if [ $# -lt 3 ] && [ $# -gt 1 ] ; then
  echo "Two arguments recieved"
else
  echo "Error, needs 2 arguments \n Arg1: Location of block device \n Arg2: Location of LVM Root"
  exit 1
fi

pvresize $1
lvextend $2 -l+100%FREE
resize2fs $2

exit 0
