#!/bin/bash
input="$(cat)"
input() { printf %s "$input" ;}
printf "\ePtmux;\e\e]52;c;$( input | base64 )\x07\e\\"
