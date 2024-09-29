#!/bin/bash

# ./build_sh_conf should contain your version of
#EXCLUDES=excludes
#REMOTE_SERVERS="nvme4:IM_SERVER=yes nvme5:IM_SERVER=yes nvme11:IM_SERVER=yes nvme12:IM_SERVER=yes nvme13:IM_SERVER=yes nvme21:IM_CLIENT=yes"
#REMOTE_DIR=workdir

COMMIT_ID=$(git log -n1 --format=%h)
CHANGE_ID=$(git log -n1 --format=%b | awk '/^Change-Id: / {print $2}')

cd "$(git rev-parse --show-toplevel)"
source ./build_sh_conf

OPTS="--force --ignore-errors --exclude-from=$EXCLUDES --delete -av"


w=0

if [ $w == 1 ] ; then

for rs in $REMOTE_SERVERS; do
	machine_name=`echo $rs | cut -d: -f1`
	machine_type=`echo $rs | cut -d: -f2`
	echo "-----------------------------------------------------------------"
	echo "now working on " $machine_name
	echo "-----------------------------------------------------------------"
	ssh $machine_name "mkdir -pv $REMOTE_DIR"
	rsync $OPTS . -e 'ssh' $machine_name:$REMOTE_DIR
	ssh $machine_name "cd $REMOTE_DIR; make $1 all $machine_type COMMIT_ID=$COMMIT_ID"
done

else
set -x
nvme60
	machine_name="nvme60"
	machine_type="IM_BOTH=yes:MK_RPM=yes"

	echo "now working on " $machine_name
	echo "---1"
	ssh -p 1060 localhost "mkdir -pv $REMOTE_DIR"
	echo "---2"
	rsync $OPTS . -e 'ssh -p 1060 localhost' :$REMOTE_DIR
	echo "---3"
	#ssh -p 1060 localhost "cd $REMOTE_DIR; make $1 all $machine_type"
	ssh -p 1060 localhost "cd $REMOTE_DIR; make $1 all $machine_type COMMIT_ID=$COMMIT_ID"

fi



