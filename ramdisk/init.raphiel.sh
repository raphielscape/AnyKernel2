#!/system/bin/sh
# Copyright (C) 2018 Raphielscape LLC.
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Bash additional script file for Kat Kernel
#
# DO NOT MODIFY THIS FILE
 
write() {
    echo -n "$2" > "$1"
}
 
copy() {
    cat "$1" > "$2"
}
 
get-set-forall() {
    for f in $1 ; do
        cat "$f"
        write "$f" "$2"
    done
}
 
delett() {
    rm -rf "$1"
}
 
{
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq 0;
write /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq 0;
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable 1;
write /sys/devices/system/cpu/cpu4/cpufreq/schedutil/iowait_boost_enable 1;
}&