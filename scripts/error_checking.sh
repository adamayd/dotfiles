#! /bin/bash

error_exit()
{
  echo "$1" 1>&2
  exit 1
}

if cd $1; then
  echo "Found It!!"
else
  error_exit "Change Directory Error!  Aborting."
fi

exit 0
