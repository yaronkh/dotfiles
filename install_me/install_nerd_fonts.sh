#!/bin/bash

#check that 0XProto is installed.
if ! fc-list | grep -q "ProtoNerdFont"; then
    cd ~/.fonts/ || exit 255
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/0xProto.zip
    unzip 0xProto.zip
    rm 0xProto.zip
    fc-cache -fv
fi


