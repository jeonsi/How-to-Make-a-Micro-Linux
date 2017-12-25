HOSTNAME=MicroLinux
PARALLEL_JOBS=`cat /proc/cpuinfo | grep cores | wc -l `

help:
	@echo "Makefile for Building Micro Linux."
	@echo "Usage: make [ all | buildroot | kernel | busybox | rootfs | isoimage | run | clean | help ] "
	@echo ""
	@echo

all: kernel busybox rootfs isoimage buildroot

kernel:
	@echo "Building Kernel"
	@mkdir -pv out
	@rm -rf out/linux-4.11.3
	@tar -xf packages/linux-4.11.3.tar.xz -C out
	make -C out/linux-4.11.3 mrproper
	make -C out/linux-4.11.3 defconfig
	@sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\""$(HOSTNAME)"\"/" out/linux-4.11.3/.config
	make -C out/linux-4.11.3 bzImage -j $(PARALLEL_JOBS)

busybox:
	@echo "Building Busybox"
	@mkdir -pv out
	@rm -rf out/busybox-1.27.2
	@tar -xf packages/busybox-1.27.2.tar.bz2 -C out
	make  -C out/busybox-1.27.2 clean
	make  -C out/busybox-1.27.2 defconfig
	@sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" out/busybox-1.27.2/.config
	make  -C out/busybox-1.27.2 busybox -j $(PARALLEL_JOBS)
	make  -C out/busybox-1.27.2 install

rootfs:
	@echo "Building Root File System"
	@rm -rf out/rootfs
	@mkdir -v -pv out/rootfs
	@cp -Rv out/busybox-1.27.2/_install/* out/rootfs
	@rm -v out/rootfs/linuxrc
	@mkdir -v out/rootfs/dev out/rootfs/etc out/rootfs/proc out/rootfs/root out/rootfs/src out/rootfs/sys out/rootfs/tmp
	@chmod -v 1777 out/rootfs/tmp
	@cp -v packages/rootfs/init out/rootfs/
	@cp -v packages/rootfs/etc/* out/rootfs/etc/
	@chmod -v +x out/rootfs/etc/bootscript.sh
	@chmod -v +x out/rootfs/etc/rc.dhcp
	@chmod -v +x out/rootfs/init

buildroot:
	@echo "Building Root File System from buildroot"
	@rm -rf out/buildroot-2017.11
	@tar -xf packages/buildroot-2017.11.tar.bz2 -C out
	make -C out/buildroot-2017.11 clean
	@cp my_qemu_x86_64_defconfig out/buildroot-2017.11/configs
	make -C out/buildroot-2017.11 my_qemu_x86_64_defconfig
	@cp -R ~/dl out/buildroot-2017.11
	@cp linux-4.11.config out/buildroot-2017.11/board/qemu/x86_64
	make -C out/buildroot-2017.11

isoimage:
	@echo "Building ISO image"
	@rm -rf out/isoimage out/syslinux-6.03
	@mkdir -p out/isoimage
	@cp out/linux-4.11.3/arch/x86/boot/bzImage out/isoimage/vmlinuz
	@cd out/rootfs && find . | cpio -R root:root -H newc -o | gzip > ../isoimage/initrd.gz
	@tar -xf packages/syslinux-6.03.tar.xz -C out
	@cp out/syslinux-6.03/bios/core/isolinux.bin out/isoimage
	@cp out/syslinux-6.03/bios/com32/elflink/ldlinux/ldlinux.c32 out/isoimage
	@echo "default vmlinuz initrd=initrd.gz quiet splash" > out/isoimage/isolinux.cfg
	@cd out/isoimage && genisoimage \
		-J \
		-r \
		-o ../../MicroLinux.iso \
		-b isolinux.bin \
		-c boot.cat \
		-input-charset UTF-8 \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		-joliet-long \
		./

run:
	@qemu-system-x86_64 -cdrom MicroLinux.iso -k en-us

clean:
	@rm -rf out MicroLinux.iso

.PHONY: all kernel busybox rootfs isoimage clean
