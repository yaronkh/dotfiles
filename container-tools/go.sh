#!/bin/bash

function mountbind() {
    [ -d $2 ] || mkdir $2
    mountpoint $2 > /dev/null || sudo mount --bind /$1 $2
}

homedir=$(echo ~)
homedir=${homedir:1}
mkdir -p $homedir
chmod 777 $homedir

for d in lib64 lib bin usr sbin tmp proc dev sys etc
do
    mountbind /$d $d
done

sudo chroot --userspec yaron . /bin/bash

for d in lib64 lib bin usr sbin tmp proc dev sys etc
do
    if mountpoint $d; then sudo umount $d; fi
done



