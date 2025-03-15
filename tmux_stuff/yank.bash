#!/bin/bash
input="$@"
input() { printf %s "$input" ;}
# copy via OSC 52
printf "\033]52;c;$( input | base64 )\a"
