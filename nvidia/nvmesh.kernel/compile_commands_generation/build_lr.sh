#!/bin/bash

is_remote=1
while getopts ":n:rl" opt; do
	#echo "opt is ${opt}"
	case ${opt} in
	n)
		#echo "machine ${OPTARG}"
		machine=$OPTARG
		;;
	r)
		#echo "remote"
		is_remote=1
		;;
	l)
		#echo "local"
		is_remote=0
		;;
	\?)
		#echo "Invalid option -$OPTARG" >&2
		is_remote=1
		;;
	esac
done
#echo "is_remote=${is_remote}"
BUILD_CMD=./build.sh
if [[ "is_remote" -eq 1 ]]; then
	source=build_sh_conf.remote
	CMD_ARG=
else
	source=build_sh_conf.local
	CMD_ARG=--run-local
fi

#echo "source config file is ${source}"
#cp $source build_sh_conf
#if [ $? -ne 0 ]; then
#	#echo "Fail to copy ${source} to build_sh_conf"
#	exit 1
#fi
#echo "./build.sh"
${BUILD_CMD} --conf $source ${CMD_ARG}
#echo "build.sh return code $#"
if [ $# -eq 1 ]; then
#if false; then
	if [[ "is_remote" -eq 0 ]]; then
		machine="${machine:-n224}"
		#echo "remote machine is ${machine}"
		#echo "remote dir is ${REMOTE_DIR}"
		source ${source}
		#echo "kernel source is located at ${KERNEL_SRC}"
		if [ -z "${KERNEL_SRC}" ]; then
			#echo "no source"
			dir=.
		else
			#echo "has source"
			dir=${KERNEL_SRC}
		fi
		#ssh ${machine} "cd ${REMOTE_DIR}; ./gen_compile_commands.py -r ${dir}"
		#scp ${machine}:${REMOTE_DIR}/compile_commands.json ~/${LOCAL_DIR}/
		#ssh ${machine} "cd ${REMOTE_DIR}; ./build_compile_db.sh ./tools/toma_rpc"
		#scp ${machine}:${REMOTE_DIR}/tools/toma_rpc/compile_commands.json ~/${LOCAL_DIR}/tools/toma_rpc/
		#ssh ${machine} "cd ${REMOTE_DIR}; ./build_compile_db.sh ./perfTest/io_stress/cmp_blocks"
		#scp ${machine}:${REMOTE_DIR}/perfTest/io_stress/cmp_blocks/compile_commands.json ~/${LOCAL_DIR}/perfTest/io_stress/cmp_blocks/
		#ssh ${machine} "cd ${REMOTE_DIR}; ./build_compile_db.sh ./perfTest/io_stress/di_parser"
		#scp ${machine}:${REMOTE_DIR}/perfTest/io_stress/di_parser/compile_commands.json ~/${LOCAL_DIR}/perfTest/io_stress/di_parser/
		#ssh ${machine} "cd ${REMOTE_DIR}; ./build_compile_db.sh ./perfTest/io_stress/scan_locks"
		#scp ${machine}:${REMOTE_DIR}/perfTest/io_stress/scan_locks/compile_commands.json ~/${LOCAL_DIR}/perfTest/io_stress/scan_locks/
		#ssh ${machine} "cd ${REMOTE_DIR}; ./build_compile_db.sh ./toma"
		#scp ${machine}:${REMOTE_DIR}/toma/compile_commands.json ~/${LOCAL_DIR}/toma/

		#while read line; do
		#	dir=`dirname ${line}`
		#	mkdir -p ${dir}
		#	#echo "${REMOTE_DIR}/${line}"
		#	#echo "~/${LOCAL_DIR}/${line}"
		#	scp ${machine}:${REMOTE_DIR}/${line} ~/${LOCAL_DIR}/${line}
		#done <<< "$(ssh ${machine} "cd ${REMOTE_DIR}; find . -type f -name \"gen_events.h\"")"

		cd ~/${REMOTE_DIR}; ./gen_compile_commands.py -r ${dir}
		cd ~/${REMOTE_DIR}; ./build_compile_db.sh ./tools/toma_rpc
		cd ~/${REMOTE_DIR}; ./build_compile_db.sh ./perfTest/io_stress/cmp_blocks
		cd ~/${REMOTE_DIR}; ./build_compile_db.sh ./perfTest/io_stress/di_parser
		cd ~/${REMOTE_DIR}; ./build_compile_db.sh ./perfTest/io_stress/scan_locks
		cd ~/${REMOTE_DIR}; ./build_compile_db.sh ./toma
	fi
fi
