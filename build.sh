#!/bin/bash

set -eo pipefail

CURPATH=`pwd`
UBOOT=$CURPATH/uboot
KERNEL=$CURPATH/kernel
BUSYBOX=$CURPATH/busybox
ROOTFS=$CURPATH/rootfs
WIFIDRIVER=$CURPATH/rtl8188fu
OUT=~/tftp

COMMAND=$1

check_pack()
{
	echo "chinking uboot..."
	if [ ! -d  $CURPATH/uboot ];then
                git clone https://github.com/Jubian540/ncam-uboot.git uboot origin main
        else
                cd $CURPATH/uboot
		git pull
		cd $CURPATH
        fi
	echo "chinked uboot done."

	echo "chinking kernel..."
	if [ ! -d  $CURPATH/kernel ];then
		git clone https://github.com/Jubian540/ncam-kernel.git kernel origin ipc
		git checkout ipc
	else
		cd $CURPATH/kernel
		git pull origin ipc
		git checkout ipc
		cd $CURPATH
	fi
	echo "chinked kernel done."

	echo "chinking wifi driver..."
	if [ ! -d  $CURPATH/rtl8188fu ];then
                git https://github.com/Jubian540/rtl8188fu rtl8188fu
        else
                cd $CURPATH/rtl8188fu
                git pull
                cd $CURPATH
        fi

	echo "chinking busybox..."
	if [ ! -d  $CURPATH/busybox ];then
                git clone https://github.com/Jubian540/hi3516-busybox.git busybox
		tar xvzf $CURPATH/busybox/rootfs.tgz -C .
        else
                cd $CURPATH/busybox
                git pull
		cd $CURPATH
		if [ ! -d $CURPATH/rootfs ];then
			tar xvzf $CURPATH/busybox/rootfs.tgz -C .
		fi
        fi
	echo "chinked busybox done."
}

build_uboot()
{
	cd $UBOOT
	$UBOOT/build.sh
	cp $UBOOT/u-boot-hi3516ev200.bin $OUT/u-boot.bin
}

build_kernel()
{
	cd $KERNEL
	$KERNEL/build.sh
	cp $KERNEL/kernel.bin $OUT/kernel

	cd $WIFIDRIVER
	$WIFIDRIVER/build.sh
}

build_rootfs()
{
	$ROOTFS/mkimg.rootfs $ROOTFS $OUT rootfs jffs2
}

if [ ! -d $OUT ];then
	mkdir $OUT
fi

if [ -z "$COMMAND" ];then
	build_uboot
	build_kernel
	build_rootfs
else
	case $1 in
	'check')
		check_pack
		;;
	'uboot')
		build_uboot
		;;
	'kernel')
		build_kernel
		;;
	'rootfs')
		build_rootfs
		;;
	esac
fi
