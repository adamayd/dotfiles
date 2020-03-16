#!/bin/bash

printf "%s\n" "Press any key to open Firefox and set up syncing.  Close Firefox when finished"
read -p "Enter s to skip: " skipper
echo $skipper
if [[ $skipper != 's' ]] && [[ $skipper != 'S' ]]; then
  firefox -new-tab "https://www.mozilla.org/en-US/firefox/developer/"
fi
