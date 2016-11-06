#!/bin/bash

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
KERNEL="Image.gz-dtb"
DEFCONFIG="yarpiin_defconfig"
KERNEL_DIR="/home/slawek/Android/Yarpiin-Kernel-OP2-CM14"
RESOURCE_DIR="/home/slawek/Android/Yarpiin-Kernel-OP2-CM14"
ANYKERNEL_DIR="/home/slawek/Android/Kernelzip/YARPIIN.OP2.CM14.alpha"

# Kernel Details
BASE_YARPIIN_VER="-YARPIIN.OP2.CM14"
VER=".alpha3"
YARPIIN_VER="$BASE_YARPIIN_VER$VER"

# Vars
export LOCALVERSION=`echo $YARPIIN_VER`
export CROSS_COMPILE="/home/slawek/Android/Toolchains/aarch64-linux-android-4.9-kernel/bin/aarch64-linux-android-"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=yarpiin
export KBUILD_BUILD_HOST=kernel

# Paths
REPACK_DIR="/home/slawek/Android/Kernelzip/YARPIIN.OP2.CM14.alpha"
PATCH_DIR="/home/slawek/Android/Kernelzip/YARPIIN.OP2.CM14.alpha/patch"
MODULES_DIR="/home/slawek/Android/Kernelzip/YARPIIN.OP2.CM14.alpha/modules"
ZIP_MOVE="/home/slawek/Android/Kernelzip"
ZIMAGE_DIR="/home/slawek/Android/Yarpiin-Kernel-OP2-CM14/arch/arm64/boot"

# Functions
function clean_all {
		echo; ccache -c -C echo;
		if [ -f "$MODULES_DIR/*.ko" ]; then
			rm `echo $MODULES_DIR"/*.ko"`
		fi
		cd $REPACK_DIR
		rm -rf $KERNEL
		cd $KERNEL_DIR
		echo
		make clean && make mrproper
}

function make_kernel {
		echo
		make ARCH=arm64 CROSS_COMPILE=/home/slawek/Android/Toolchains/aarch64-linux-android-4.9-kernel/bin/aarch64-linux-android- yarpiin_defconfig
		make ARCH=arm64 CROSS_COMPILE=/home/slawek/Android/Toolchains/aarch64-linux-android-4.9-kernel/bin/aarch64-linux-android-
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/$KERNEL
}


function make_zip {
		cd /home/slawek/Android/Kernelzip/YARPIIN.OP2.CM14.alpha
		zip -r `echo $YARPIIN_VER`.zip *
		mv  `echo $YARPIIN_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}


DATE_START=$(date +"%s")

echo -e "${green}"
echo "Yarpiin Kernel Creation Script:"
echo

echo "---------------"
echo "Kernel Version:"
echo "---------------"

echo -e "${red}"; echo -e "${blink_red}"; echo "$YARPIIN_VER"; echo -e "${restore}";

echo -e "${green}"
echo "----------------------"
echo "Making YARPIIN Kernel:"
echo "----------------------"
echo -e "${restore}"

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_kernel
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to zip kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo

