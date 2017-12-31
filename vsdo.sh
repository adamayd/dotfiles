#!/bin/bash

if [! -z "$1"]; then
    printf ",s/^wheel ALL=(ALL) ALL$/%wheel ALL=(ALL) ALL\nw\nq\n" | ed $1
else
    export EDITOR=$0
    visudo
fi