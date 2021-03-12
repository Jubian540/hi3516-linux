#!/bin/bash

set -eo pipefail

CURPATH=`pwd`
UBOOT=$CURPATH/uboot
KERNEL=$CURPATH/kernel
BUSYBOX=$CURPATH/busybox
ROOTFS=$CURPATH/rootfs
OUT=$CURPATH/out

check_pack()
{
	echo "chinking uboot..."
	if [ ! -d  $CURPATH/uboot ];then
                git clone https://github.com/Jubian540/ncam-uboot.git uboot
        else
                cd $CURPATH/uboot
		git pull
		cd $CURPATH
        fi
	echo "chinked uboot done."

	echo "chinking kernel..."
	if [ ! -d  $CURPATH/kernel ];then
		git clone https://github.com/Jubian540/ncam-kernel.git kernel
	else
		cd $CURPATH/kernel
		git pull
		cd $CURPATH
	fi
	echo "chinked kernel done."

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

check_pack
