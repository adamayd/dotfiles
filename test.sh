#!/bin/bash

error_exit() {
  echo "Error in $1 section. Exiting" 1>&2
  exit 1
}

install_a() {
  ls
}

install_b() {
  afafsf
}

install_a || error_exit "a"
install_b || error_exit "b"

exit 0


