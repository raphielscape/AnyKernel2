# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Disrupt Kramel by @raphielscape
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=1
device.name1=beryllium
device.name2=dipper
device.name3=polaris
supported.versions=
supported.patchlevels=
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
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;


## AnyKernel install
dump_boot;

# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
# And notify about Magisk preservation in case of Android 10
android_version="$(file_getprop /system/build.prop "ro.build.version.release")";
# Do not do this for Android 10 ( A only SAR )
if [ "$android_version" != "10" ]; then
  if [ -d $ramdisk/.backup ]; then
    ui_print " "; ui_print "Magisk detected! Patching cmdline so reflashing Magisk is not necessary...";
    patch_cmdline "skip_override" "skip_override";
  else
    patch_cmdline "skip_override" "";
  fi;
else
  ui_print " "; ui_print "You are on android 10! Not performing Magisk preservation. Please reflash Magisk if you want to keep it.";
fi;

# Set magisk policy
ui_print "Setting up magisk policy for SELinux...";
$bin/magiskpolicy --load sepolicy --save sepolicy "allow init rootfs file execute_no_trans";
$bin/magiskpolicy --load sepolicy_debug --save sepolicy_debug "allow init rootfs file execute_no_trans";

# Write boot
write_boot;
## end install

