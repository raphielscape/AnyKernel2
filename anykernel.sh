# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Kat Kernel by @raphielscape
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=beryllium
device.name2=dipper
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;


## AnyKernel install
dump_boot;

# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
if [ -d $ramdisk/.backup ]; then
    ui_print "Magisk detected! Patching cmdline so reflashing Magisk is not necessary...";
    patch_cmdline "skip_override" "skip_override";
else
    patch_cmdline "skip_override" "";
fi;

# Set magisk policy
ui_print "Setting up magisk policy for SELinux...";
$bin/magiskpolicy --load sepolicy --save sepolicy "allow init rootfs file execute_no_trans";
$bin/magiskpolicy --load sepolicy_debug --save sepolicy_debug "allow init rootfs file execute_no_trans";

# Write boot
write_boot;
## end install

