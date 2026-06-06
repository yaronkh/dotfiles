#!/bin/bash

# Helper for starting nvmeshum
#
# If built with shared SPDK, add non-stripped SPDK libs to library path

app_dir=$(dirname $(readlink -f $0))

if [ $EUID -ne 0 ]; then
	echo "Needs to run as root"
	exit 1
fi

source $app_dir/.config

echo "ld lib path: ${LD_LIBRARY_PATH}"
if [ "$SHARED" == "y" ]; then
	SPDK_BUILD_LIB=$(realpath $SPDK_ROOT_DIR/build/lib)
	DPDK_BUILD_LIB=$(realpath $SPDK_ROOT_DIR/dpdk/build/lib)
	LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SPDK_BUILD_LIB}:${DPDK_BUILD_LIB}"
	if [ "$BUILD_TYPE" == "SNAP_BT" ] || [ "$BUILD_TYPE" == "SNAPUM_BT" ]; then
		if [ "$SNAP4" == "y" ]; then
			SNAP_BUILD_LIB="$(realpath $SNAP_LIB_ROOT/build/libs):$(realpath $SNAP_LIB_ROOT/build/service)"
			source $SNAP_LIB_ROOT/scripts/set_environment_variables.sh
			export LIBSNAP_DPA_DIR="$SNAP_LIB_ROOT/subprojects/core/dpa_app"
		else
			SNAP_BUILD_LIB=$(realpath $SNAP_RDMA_ROOT/rpc/.libs)
		fi
		LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SNAP_BUILD_LIB}"
	fi
fi

if [ "$IN_CONTAINER" == "true" ]; then
	EXTRA_PARAMS+=" --iova-mode=va"
else
	$app_dir/scripts/setup_hugepages.sh
fi

# Add anonymous + file-backed + hugepages + ELF headers to core dump
echo 0x13f | tee /proc/self/coredump_filter

if [ "$IN_CONTAINER" != "true" ]; then
	# Put no limit on the core file size
	ulimit -c unlimited
fi

# Set path for mparam conf
if [ -f "$SYSCONF_DIR/nvmeshum_mparam.conf" ]; then
	export UM_MPARAM_CONF_PATH="$SYSCONF_DIR/nvmeshum_mparam.conf"
else
	export UM_MPARAM_CONF_PATH="$app_dir/config/nvmeshum_mparam.conf"
fi

#enough for simulator
ulimit -n 9068

#On Ubuntu 24.04 this option changed from 0 to 1 - our cooperative multithreading is not ready for this
export ASAN_OPTIONS=detect_stack_use_after_return=0
if ! modprobe ublk_drv ; then
        echo "Failed to load ublk_drv module"
        exit 1
fi
LD_LIBRARY_PATH="$LD_LIBRARY_PATH" gdb --args $app_dir/nvmeshum $EXTRA_PARAMS -r $SPDK_SOCK $@
