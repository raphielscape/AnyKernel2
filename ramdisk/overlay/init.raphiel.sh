#!/system/bin/sh
# Copyright (C) 2018 Raphielscape LLC.
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Bash additional script file for Kat Kernel
#
# DO NOT MODIFY THIS FILE

write() {
    echo "$2" > "$1"
}

copy() {
    cat "$1" > "$2"
}

delett() {
    rm -rf "$1"
}

{
# configure governor settings for little cluster
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor schedutil
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us 500
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us 20000
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq 0
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable 1

# configure governor settings for big cluster
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor schedutil
write /sys/devices/system/cpu/cpu4/cpufreq/schedutil/up_rate_limit_us 500
write /sys/devices/system/cpu/cpu4/cpufreq/schedutil/down_rate_limit_us 20000
write /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq 0
write /sys/devices/system/cpu/cpu4/cpufreq/schedutil/iowait_boost_enable 1

# set default schedTune value for foreground/top-app
write /dev/stune/foreground/schedtune.prefer_idle 1
write /dev/stune/top-app/schedtune.boost 10
write /dev/stune/top-app/schedtune.prefer_idle 1

write /sys/module/workqueue/parameters/power_efficient Y

# Disable CAF task placement for Big Cores
write /proc/sys/kernel/sched_walt_rotate_big_tasks 0

# Disable Autogrouping
write /proc/sys/kernel/sched_autogroup_enabled 0

# Adjust SCHED Features
write /sys/kernel/debug/sched_features NO_EAS_USE_NEED_IDLE
write /sys/kernel/debug/sched_features TTWU_QUEUE

# Setup EAS cpusets values for better load balancing
write /dev/cpuset/top-app/cpus 0-7

# Since we are not using core rotator, lets load balance
write /dev/cpuset/foreground/cpus 0-3,6-7
write /dev/cpuset/background/cpus 0-1
write /dev/cpuset/system-background/cpus 0-3

# For better screen off idle
write /dev/cpuset/restricted/cpus 0-3
}&